import 'package:my_recepi_app/recipe_model.dart';

class FavoritesManager {
  static final List<Recipe> _favorites = [];

  static List<Recipe> get favorites => _favorites;

  static void addToFavorites(Recipe recipe) {
    if (!_favorites.any((r) => r.id == recipe.id)) {
      _favorites.add(recipe);
    }
  }

  static void removeFromFavorites(Recipe recipe) {
    _favorites.removeWhere((r) => r.id == recipe.id);
  }

  static bool isFavorite(Recipe recipe) {
    return _favorites.any((r) => r.id == recipe.id);
  }
}
