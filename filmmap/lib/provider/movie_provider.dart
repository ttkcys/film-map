import 'package:filmmap/model/movie_model.dart';
import 'package:filmmap/service/movie_service.dart';
import 'package:flutter/material.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<Movie> _popularMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _genreMovies = [];

  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get genreMovies => _genreMovies;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    notifyListeners();

    _popularMovies = await _movieService.getPopularMovies();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchNowPlayingMovies() async {
    _isLoading = true;
    notifyListeners();

    _nowPlayingMovies = await _movieService.getNowPlayingMovies();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUpcomingMovies() async {
    _isLoading = true;
    notifyListeners();

    _upcomingMovies = await _movieService.getUpcomingMovies();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTopRatedMovies() async {
    _isLoading = true;
    notifyListeners();

    _topRatedMovies = await _movieService.getTopRatedMovies();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoviesByGenre(int genreId) async {
    _isLoading = true;
    notifyListeners();

    _genreMovies = await _movieService.fetchMoviesByGenre(genreId);

    _isLoading = false;
    notifyListeners();
  }
}
