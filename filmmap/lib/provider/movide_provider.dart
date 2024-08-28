import 'package:filmmap/model/movie_model.dart';
import 'package:filmmap/service/movide_service.dart';
import 'package:flutter/material.dart';

class MovieProvider with ChangeNotifier {
  Movie? _movie;
  bool _isLoading = true;

  Movie? get movie => _movie;
  bool get isLoading => _isLoading;

  final MovieService _movieService = MovieService();

  MovieProvider() {
    fetchMovie();
  }

  Future<void> fetchMovie() async {
    _isLoading = true;
    notifyListeners();

    _movie = await _movieService.fetchPopularMovie();

    _isLoading = false;
    notifyListeners();
  }
}
