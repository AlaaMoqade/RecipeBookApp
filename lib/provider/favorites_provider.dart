import 'package:flutter/material.dart';
import 'package:recipe_gsg/models/recipy.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'dart:convert';

class FavoritesProvider extends ChangeNotifier {
  List<Recipe> _favorites = [];

  List<Recipe> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  void toggleFavorite(Recipe recipe) {
    if (_favorites.any((item) => item.id == recipe.id)) {
      _favorites.removeWhere((item) => item.id == recipe.id);
    } else {
      _favorites.add(recipe);
    }
    _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(Recipe recipe) {
    return _favorites.any((item) => item.id == recipe.id);
  }

  Future<void> _saveFavorites() async {
    final jsonString = jsonEncode(_favorites.map((r) => r).toList());
    await SharedPrefs.saveFavorites(jsonString);
  }

  Future<void> _loadFavorites() async {
    final jsonString = await SharedPrefs.getFavorites();
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      _favorites = decoded.map((e) => Recipe.fromJson(e)).toList();
      notifyListeners();
    }
  }
}
