import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  int get totalFavorites => _favorites.length;

  bool isFavorite(String nombre) {
    return _favorites.any((t) => t["nombre"] == nombre);
  }

  void toggleFavorite(Map<String, dynamic> torta) {
    final index = _favorites.indexWhere((t) => t["nombre"] == torta["nombre"]);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(torta);
    }
    notifyListeners();
  }
}
