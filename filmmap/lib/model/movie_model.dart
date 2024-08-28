class Movie {
  final String title;
  final String backdropPath;
  final String overview;

  Movie({
    required this.title,
    required this.backdropPath,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      overview: json['overview'] ?? '',
    );
  }
}
