import 'package:filmmap/model/tv_model.dart';
import 'package:filmmap/pages/tv_detail_page.dart';
import 'package:filmmap/provider/tv_provider.dart';
import 'package:filmmap/utils/genre_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class HomeTvShowPage extends StatefulWidget {
  const HomeTvShowPage({super.key});

  @override
  State<HomeTvShowPage> createState() => _HomeTvShowPageState();
}

class _HomeTvShowPageState extends State<HomeTvShowPage> {
  String _selectedCategory = 'Popüler';
  String _selectedGenre = 'Tümü';
  List<TvShow> _currentTvShows = [];

  final Map<String, String> _categoryMap = {
    'Popüler': 'popular',
    'Bugün Yayınlanıyor': 'airing_today',
    'Şu Anda Yayında': 'on_the_air',
    'En Çok Oy Alan': 'top_rated',
  };

  @override
  void initState() {
    super.initState();
    // Default olarak popüler TV şovlarını yükle
    Future.microtask(() => Provider.of<TvShowProvider>(context, listen: false)
        .fetchPopularTvShows());
  }

  void _onCategoryChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedCategory = newValue;
        // Seçilen kategoriye göre TV şovlarını yükle
        final tvShowProvider =
            Provider.of<TvShowProvider>(context, listen: false);
        switch (_categoryMap[newValue]) {
          case 'popular':
            tvShowProvider.fetchPopularTvShows();
            _currentTvShows = tvShowProvider.popularTvShows;
            break;
          case 'airing_today':
            tvShowProvider.fetchAiringTodayTvShows();
            _currentTvShows = tvShowProvider.airingTodayTvShows;
            break;
          case 'on_the_air':
            tvShowProvider.fetchOnTheAirTvShows();
            _currentTvShows = tvShowProvider.onTheAirTvShows;
            break;
          case 'top_rated':
            tvShowProvider.fetchTopRatedTvShows();
            _currentTvShows = tvShowProvider.topRatedTvShows;
            break;
        }
      });
    }
  }

  void _onGenreChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedGenre = newValue;
        final genreId = reverseGenreMap[newValue] ?? 0;
        if (genreId != 0) {
          Provider.of<TvShowProvider>(context, listen: false)
              .fetchTvShowsByGenre(genreId);
        } else {
          _onCategoryChanged(_selectedCategory);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TvShowProvider>(
          builder: (context, tvShowProvider, child) {
            if (tvShowProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }

            // Doğru listeyi belirle
            List<TvShow> tvShowsToShow = [];
            switch (_selectedCategory) {
              case 'Popüler':
                tvShowsToShow = tvShowProvider.popularTvShows;
                break;
              case 'Bugün Yayınlanıyor':
                tvShowsToShow = tvShowProvider.airingTodayTvShows;
                break;
              case 'Şu Anda Yayında':
                tvShowsToShow = tvShowProvider.onTheAirTvShows;
                break;
              case 'En Çok Oy Alan':
                tvShowsToShow = tvShowProvider.topRatedTvShows;
                break;
            }

            if (tvShowsToShow.isEmpty) {
              return const Center(child: Text("TV Şovu bulunamadı"));
            }

            return Stack(
              children: [
                // Arka plan görüntüsü (background image)
                PageView.builder(
                  itemCount: tvShowsToShow.length,
                  itemBuilder: (context, index) {
                    final TvShow tvShow = tvShowsToShow[index];
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${tvShow.backgroundPath}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Bulanık efekt (blur effect)
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                        // İçerik
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // TV Şovunun adı
                              Text(
                                tvShow.name,
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              // Poster resmi
                              Container(
                                width: 150,
                                height: 225,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Details butonu
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TvDetailPage(tvShow: tvShow),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                child: const Text('Details'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Dropdown'ların yerleştirildiği alanı üst katmana taşıyoruz
                Column(
                  children: [
                    Container(
                      color:
                          Colors.black.withOpacity(0.4), // Transparan arka plan
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Kategori DropdownButton
                          _buildDropdownButton(
                            value: _selectedCategory,
                            items: _categoryMap.keys.toList(),
                            onChanged: _onCategoryChanged,
                          ),
                          // Tür DropdownButton
                          _buildDropdownButton(
                            value: _selectedGenre,
                            items: ['Tümü', ...genreMap.values.toList()],
                            onChanged: _onGenreChanged,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDropdownButton({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      dropdownColor: Colors.black.withOpacity(0.5),
      style: const TextStyle(color: Colors.white),
      underline: Container(), // Alt çizgiyi kaldırıyoruz
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
