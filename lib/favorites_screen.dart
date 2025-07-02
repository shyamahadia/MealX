
import 'package:flutter/material.dart';
import 'package:my_recepi_app/favorites_manager.dart';
import 'package:my_recepi_app/recipe_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesManager.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Recipes")),
      body:
          favorites.isEmpty
              ? const Center(child: Text("No favorite recipes yet."))
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final recipe = favorites[index];
                  return ListTile(
                    leading: Image.network(
                      recipe.imageUrl,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(recipe.title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => RecipeDetailsScreen(recipeId: recipe.id),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}

