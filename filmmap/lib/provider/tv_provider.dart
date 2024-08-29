import 'package:filmmap/model/tv_model.dart';
import 'package:filmmap/service/tv_service.dart';
import 'package:flutter/material.dart';

class TvShowProvider with ChangeNotifier {
  final TvShowService _tvShowService = TvShowService();

  List<TvShow> _popularTvShows = [];
  List<TvShow> _airingTodayTvShows = [];
  List<TvShow> _onTheAirTvShows = [];
  List<TvShow> _topRatedTvShows = [];
  List<TvShow> _genreTvShows = [];

  List<TvShow> get popularTvShows => _popularTvShows;
  List<TvShow> get airingTodayTvShows => _airingTodayTvShows;
  List<TvShow> get onTheAirTvShows => _onTheAirTvShows;
  List<TvShow> get topRatedTvShows => _topRatedTvShows;
  List<TvShow> get genreTvShows => _genreTvShows;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchPopularTvShows() async {
    _isLoading = true;
    notifyListeners();

    _popularTvShows = await _tvShowService.getPopularTvShows();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAiringTodayTvShows() async {
    _isLoading = true;
    notifyListeners();

    _airingTodayTvShows = await _tvShowService.getAiringTodayTvShows();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchOnTheAirTvShows() async {
    _isLoading = true;
    notifyListeners();

    _onTheAirTvShows = await _tvShowService.getOnTheAirTvShows();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTopRatedTvShows() async {
    _isLoading = true;
    notifyListeners();

    _topRatedTvShows = await _tvShowService.getTopRatedTvShows();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTvShowsByGenre(int genreId) async {
    _isLoading = true;
    notifyListeners();

    _genreTvShows = await _tvShowService.fetchTvShowsByGenre(genreId);

    _isLoading = false;
    notifyListeners();
  }
}
