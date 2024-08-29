import 'dart:convert';
import 'package:filmmap/model/cast_model.dart';
import 'package:filmmap/model/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = '5c0902affbd161a4ef5e884f611170e0';
  final String _language = 'tr-TR';

  Future<List<Movie>> fetchMovies(String category) async {
    final url =
        '$_baseUrl/movie/$category?api_key=$_apiKey&language=$_language';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("API Response: $data"); // API yanıtını kontrol et
      final List results = data['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> fetchMoviesByGenre(int genreId) async {
    final url =
        '$_baseUrl/discover/movie?api_key=$_apiKey&language=$_language&with_genres=$genreId';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Genres data: ${data['genres']}");
      final List results = data['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Cast>> fetchCast(int movieId) async {
    final url =
        '$_baseUrl/movie/$movieId/credits?api_key=$_apiKey&language=$_language';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['cast'];
      return results.map((cast) => Cast.fromJson(cast)).toList();
    } else {
      throw Exception('Failed to load cast');
    }
  }

  Future<List<Movie>> getPopularMovies() => fetchMovies('popular');
  Future<List<Movie>> getNowPlayingMovies() => fetchMovies('now_playing');
  Future<List<Movie>> getUpcomingMovies() => fetchMovies('upcoming');
  Future<List<Movie>> getTopRatedMovies() => fetchMovies('top_rated');
}
