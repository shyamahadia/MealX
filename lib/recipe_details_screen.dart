import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_recepi_app/favorites_manager.dart';
import 'package:my_recepi_app/recipe_model.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final int recipeId;
  const RecipeDetailsScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  Map<String, dynamic>? details;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/${widget.recipeId}/information?includeNutrition=true&apiKey=7aea540629144f5391d60ff7f3c2a904',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          details = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print("❌ Error loading recipe details.");
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("❌ Exception while loading details: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recipe Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!isLoading && details != null)
            IconButton(
              icon: Icon(
                FavoritesManager.isFavorite(
                      Recipe(
                        id: widget.recipeId,
                        title: details!['title'],
                        imageUrl: details!['image'],
                      ),
                    )
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                final currentRecipe = Recipe(
                  id: widget.recipeId,
                  title: details!['title'],
                  imageUrl: details!['image'],
                );
                setState(() {
                  if (FavoritesManager.isFavorite(currentRecipe)) {
                    FavoritesManager.removeFromFavorites(currentRecipe);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Removed from favorites")),
                    );
                  } else {
                    FavoritesManager.addToFavorites(currentRecipe);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Added to favorites")),
                    );
                  }
                });
              },
            ),
        ],
        backgroundColor: const Color.fromARGB(255, 2, 46, 59),
      ),
      backgroundColor: Color.fromARGB(255, 210, 226, 242),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 2, 46, 59),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (details?['image'] != null)
                      Image.network(details!['image']),
                    const SizedBox(height: 16),
                    Text(
                      details?['title'] ?? '',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 6, 52, 79),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Ingredients:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 52, 79),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...List<Widget>.from(
                      (details!['extendedIngredients'] as List).map(
                        (ingredient) => Text("• ${ingredient['original']}"),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "Instructions:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 52, 79),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      details!['instructions'] ?? "No instructions available.",
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Nutrition:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 52, 79),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...List<Widget>.from(
                      (details!['nutrition']['nutrients'] as List)
                          .take(5)
                          .map(
                            (n) => Text(
                              "${n['name']}: ${n['amount']} ${n['unit']}",
                            ),
                          ),
                    ),
                  ],
                ),
              ),
    );
  }
}
