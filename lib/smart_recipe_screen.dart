import 'package:flutter/material.dart';
import 'ai_recipe_service.dart';

class SmartRecipeScreen extends StatefulWidget {
  const SmartRecipeScreen({super.key});

  @override
  State<SmartRecipeScreen> createState() => _SmartRecipeScreenState();
}

class _SmartRecipeScreenState extends State<SmartRecipeScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _recipeResult = '';
  bool _isLoading = false;

  Future<void> _generateRecipe() async {
    if (_promptController.text.trim().isEmpty) {
      setState(() {
        _recipeResult = "Please enter some ingredients or a cooking idea.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _recipeResult = '';
    });

    try {
      final result = await AIRecipeService.generateRecipe(
        _promptController.text.trim(),
      );
      setState(() {
        _recipeResult = result;
      });
    } catch (e) {
      setState(() {
        _recipeResult = 'Failed to generate recipe: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 210, 226, 242),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 46, 59),

        title: Text(
          "Smart Recipe Generator",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // decoration: const BoxDecoration(),
          ),

          // backgroundColor: Colors.transparent,
          // body:
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _recipeResult,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 2, 46, 59),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.fromLTRB(14, 10, 14, 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  //height: 58,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _promptController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Enter ingredients or cooking idea",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 1,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 9),

                ElevatedButton(
                  onPressed: _isLoading ? null : _generateRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    //shape: RoundedRectangleBorder(
                    //  borderRadius: BorderRadius.circular(34),
                    // ),
                    minimumSize: const Size(200, 50), // width, height
                  ),

                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "Generate Recipe",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
