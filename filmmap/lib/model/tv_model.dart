import 'package:filmmap/utils/genre_map.dart';

class TvShow {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String backgroundPath;
  final double voteAverage;
  final String firstAirDate;
  final List<String> genres;

  TvShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backgroundPath,
    required this.voteAverage,
    required this.firstAirDate,
    required this.genres,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Ad bilgisi mevcut değil',
      overview: json['overview'] ?? 'Açıklama bulunmuyor.',
      posterPath: json['poster_path'] ?? '',
      backgroundPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] != null)
          ? json['vote_average'].toDouble()
          : 0.0,
      firstAirDate: json['first_air_date'] ?? 'Tarih bilgisi mevcut değil',
      genres: (json['genre_ids'] as List<dynamic>?)
              ?.map((id) => genreMap[id] ?? 'Bilinmeyen Tür')
              .toList() ??
          ['Tür bilgisi mevcut değil'],
    );
  }
}
