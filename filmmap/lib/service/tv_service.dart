import 'dart:convert';
import 'package:filmmap/model/tv_model.dart';
import 'package:http/http.dart' as http;

class TvShowService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = '5c0902affbd161a4ef5e884f611170e0';
  final String _language = 'tr-TR';

  Future<List<TvShow>> fetchTvShows(String category) async {
    final url = '$_baseUrl/tv/$category?api_key=$_apiKey&language=$_language';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("API Response: $data"); // API yanıtını kontrol et
      final List results = data['results'];
      return results.map((tvShow) => TvShow.fromJson(tvShow)).toList();
    } else {
      throw Exception('Failed to load TV shows');
    }
  }

  Future<List<TvShow>> fetchTvShowsByGenre(int genreId) async {
    final url =
        '$_baseUrl/discover/tv?api_key=$_apiKey&language=$_language&with_genres=$genreId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Genres data: ${data['genres']}"); // Genres verisini logla
      final List results = data['results'];
      return results.map((tvShow) => TvShow.fromJson(tvShow)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<TvShow>> getPopularTvShows() => fetchTvShows('popular');
  Future<List<TvShow>> getAiringTodayTvShows() => fetchTvShows('airing_today');
  Future<List<TvShow>> getOnTheAirTvShows() => fetchTvShows('on_the_air');
  Future<List<TvShow>> getTopRatedTvShows() => fetchTvShows('top_rated');
}
