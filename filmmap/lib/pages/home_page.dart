import 'package:filmmap/pages/detail_page.dart';
import 'package:filmmap/utils/genre_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import 'package:filmmap/model/movie_model.dart';
import 'package:filmmap/provider/movie_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Popüler';
  String _selectedGenre = 'Tümü';
  List<Movie> _currentMovies = [];

  final Map<String, String> _categoryMap = {
    'Popüler': 'popular',
    'Gösterimde': 'now_playing',
    'Yakında': 'upcoming',
    'En Çok Oy Alan': 'top_rated',
  };

  @override
  void initState() {
    super.initState();
    // Varsayılan olarak popüler filmleri yükle
    Future.microtask(() => Provider.of<MovieProvider>(context, listen: false)
        .fetchPopularMovies());
  }

  void _onCategoryChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedCategory = newValue;
        // Seçilen kategoriye göre filmleri yükle
        final movieProvider =
            Provider.of<MovieProvider>(context, listen: false);
        switch (_categoryMap[newValue]) {
          case 'popular':
            movieProvider.fetchPopularMovies();
            _currentMovies = movieProvider.popularMovies;
            break;
          case 'now_playing':
            movieProvider.fetchNowPlayingMovies();
            _currentMovies = movieProvider.nowPlayingMovies;
            break;
          case 'upcoming':
            movieProvider.fetchUpcomingMovies();
            _currentMovies = movieProvider.upcomingMovies;
            break;
          case 'top_rated':
            movieProvider.fetchTopRatedMovies();
            _currentMovies = movieProvider.topRatedMovies;
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
          Provider.of<MovieProvider>(context, listen: false)
              .fetchMoviesByGenre(genreId);
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
        child: Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            if (movieProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }

            // Doğru listeyi belirle
            List<Movie> moviesToShow = [];
            switch (_selectedCategory) {
              case 'Popüler':
                moviesToShow = movieProvider.popularMovies;
                break;
              case 'Gösterimde':
                moviesToShow = movieProvider.nowPlayingMovies;
                break;
              case 'Yakında':
                moviesToShow = movieProvider.upcomingMovies;
                break;
              case 'En Çok Oy Alan':
                moviesToShow = movieProvider.topRatedMovies;
                break;
            }

            if (moviesToShow.isEmpty) {
              return const Center(child: Text("Film bulunamadı"));
            }

            return Stack(
              children: [
                // Arka plan görüntüsü (background image)
                PageView.builder(
                  itemCount: moviesToShow.length,
                  itemBuilder: (context, index) {
                    final Movie movie = moviesToShow[index];
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.backgroundPath}',
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
                              // Filmin adı
                              Text(
                                movie.title,
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
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
                                          DetailPage(movie: movie),
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
