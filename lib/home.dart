import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_recepi_app/recipe_details_screen.dart';
import 'package:my_recepi_app/recipe_model.dart';
import 'package:my_recepi_app/smart_recipe_screen.dart';
import 'package:my_recepi_app/views/profile.dart';
import 'main_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  Widget currentScreen = const Home();

  TextEditingController searchController = TextEditingController();
  List<Recipe> recipes = [];

  void handleDrawerItem(String item) {
    Navigator.pop(context);
    setState(() {
      switch (item) {
        case "profile":
          currentScreen = const Profile();
          break;

        case "chatbot":
          currentScreen = const SmartRecipeScreen();
          break;

        //  case "favorites":
        //  currentScreen = const FavouritesScreen();
        //  break;

        // case "about":
        //  currentScreen = const AboutScreen();
        // break;
      }
    });
  }

  Future<void> getRecipe(String query) async {
    setState(() => isLoading = true);

    final url =
        "https://api.spoonacular.com/recipes/complexSearch?query=$query&apiKey=7aea540629144f5391d60ff7f3c2a904";

    try {
      final response = await http.get(Uri.parse(url));
      print("API Status: ${response.statusCode}");
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        setState(() {
          recipes = List<Recipe>.from(
            jsonData['results'].map((json) => Recipe.fromJson(json)),
          );
          isLoading = false;
        });

        print("Found ${recipes.length} recipes");
      } else {
        setState(() => isLoading = false);
        print("Failed to fetch recipes. Status code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching recipes: $e");
    }
  }

  Future<void> getRecipeDetails(int id) async {
    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/$id/information?includeNutrition=true&apiKey=7aea540629144f5391d60ff7f3c2a904',
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var details = jsonDecode(response.body);
      print("Recipe Details for ID $id:");
      print("Title: ${details['title']}");
      print("Ingredients:");
      List ingredients = details['extendedIngredients'];
      for (var ingredient in ingredients) {
        print("- ${ingredient['original']}");
      }
      print("Instructions: ${details['instructions']}");
      print("Nutrition Summary:");
      print(
        details['nutrition']['nutrients']
            .map((n) => "${n['name']}: ${n['amount']} ${n['unit']}")
            .join(", "),
      );
    } else {
      print("Failed to fetch recipe details");
    }
  }

  @override
  void initState() {
    super.initState();
    getRecipe("Pizza");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        // backgroundColor: Color.fromARGB(255, 210, 226, 242),
        title: Text(
          "MealX",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: const Color.fromARGB(255, 2, 46, 59),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 2, 46, 59),
      drawer: MainDrawer(onItemSelected: handleDrawerItem,
      allRecipes: recipes,),
      body:
       Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // decoration: const BoxDecoration(),
          ),
          Column(
            children: [
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // color: const Color.fromARGB(234, 252, 249, 249),
                    borderRadius: BorderRadius.circular(31),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (searchController.text.trim().isEmpty) {
                            print("blank search not supported");
                            return;
                          } else {
                            getRecipe(searchController.text.trim());
                          }
                        },
                        child: const Icon(
                          Icons.search,
                          size: 28,
                          color: Color.fromARGB(255, 23, 27, 34),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          
                          decoration: const InputDecoration(
                            hintText: "Search Any Recipe...",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 23, 27, 34),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "WHAT DO YOU WANT TO COOK TODAY?",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Let's Cook Something New!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Expanded(
                    child:
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : recipes.isEmpty
                            ? const Center(
                              child: Text(
                                'No recipes found.',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                            : ListView.builder(
                              itemCount: recipes.length,
                              itemBuilder: (context, index) {
                                final recipe = recipes[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => RecipeDetailsScreen(
                                              recipeId: recipe.id,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                    child: Container(
                                      height:
                                          140, // Increase this to make the box bigger
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.network(
                                              recipe.imageUrl,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  recipe.title,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),

              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SmartRecipeScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 50), // width, height
                ),
                child: const Text(
                  "Smart Recipe Generator",
                  style: TextStyle(
                    color: Color.fromARGB(255, 23, 27, 34),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
