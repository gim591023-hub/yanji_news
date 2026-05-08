import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_data.dart';

class AppState extends ChangeNotifier {
  Platform _selectedPlatform = Platform.internal;
  List<TrendItem> _trends = [];
  bool _isLoadingTrends = false;
  List<String> _favoriteTags = [];
  List<String> _recentSearches = [];
  int _currentTabIndex = 0;

  Platform get selectedPlatform => _selectedPlatform;
  List<TrendItem> get trends => _trends;
  bool get isLoadingTrends => _isLoadingTrends;
  List<String> get favoriteTags => _favoriteTags;
  List<String> get recentSearches => _recentSearches;
  int get currentTabIndex => _currentTabIndex;

  AppState() {
    _recentSearches = MockDataService.getRecentSearches();
    loadTrends();
  }

  Future<void> loadTrends() async {
    _isLoadingTrends = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _trends = MockDataService.getTrends(_selectedPlatform);
    _isLoadingTrends = false;
    notifyListeners();
  }

  void setPlatform(Platform p) {
    _selectedPlatform = p;
    loadTrends();
  }

  void setTabIndex(int i) {
    _currentTabIndex = i;
    notifyListeners();
  }

  void toggleFavorite(String tagName) {
    if (_favoriteTags.contains(tagName)) {
      _favoriteTags.remove(tagName);
    } else {
      _favoriteTags.add(tagName);
    }
    notifyListeners();
  }

  bool isFavorite(String tagName) => _favoriteTags.contains(tagName);

  void addRecentSearch(String query) {
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 10) _recentSearches.removeLast();
    notifyListeners();
  }

  void removeRecentSearch(String query) {
    _recentSearches.remove(query);
    notifyListeners();
  }
}
