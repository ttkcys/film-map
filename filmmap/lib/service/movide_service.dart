import 'dart:convert';
import 'package:filmmap/model/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieService {
  final String _apiKey = 'your_api_key_here'; // Replace with your TMDB API key
  final String _baseUrl = 'https://api.themoviedb.org/3/movie/popular';

  Future<Movie?> fetchPopularMovie() async {
    final response = await http.get(Uri.parse('$_baseUrl?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return Movie.fromJson(data['results'][0]); // Fetch the first movie
      }
    }
    return null;
  }
}
