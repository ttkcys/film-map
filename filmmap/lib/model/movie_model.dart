import 'package:filmmap/utils/genre_map.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backgroundPath;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backgroundPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Başlık bilgisi mevcut değil',
      overview: json['overview'] ?? 'Açıklama bulunmuyor.',
      posterPath: json['poster_path'] ?? '',
      backgroundPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] != null)
          ? json['vote_average'].toDouble()
          : 0.0,
      releaseDate: json['release_date'] ?? 'Tarih bilgisi mevcut değil',
      genres: (json['genre_ids'] as List<dynamic>?)
              ?.map((id) => genreMap[id] ?? 'Bilinmeyen Tür')
              .toList() ??
          ['Tür bilgisi mevcut değil'],
    );
  }
}
