import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 210, 226, 242),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 46, 59),
        title: Text("About Us", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "MealX 🍳",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 2, 46, 59),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to MealX - your personal recipe companion powered by AI",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 2, 46, 59),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Features:",
              style: TextStyle(
                color: const Color.fromARGB(255, 2, 46, 59),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "• Search recipes by name or ingredient",
              style: TextStyle(
                color: const Color.fromARGB(255, 2, 46, 59),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "• View detailed cooking instructions and                                      nutrition",
              style: TextStyle(
                color: const Color.fromARGB(255, 2, 46, 59),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "• Smart recipe suggestions using AI",
              style: TextStyle(
                color: const Color.fromARGB(255, 2, 46, 59),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "• Save your favorite recipes",
              style: TextStyle(
                color: const Color.fromARGB(255, 2, 46, 59),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 390),
            Text(
              "👨‍💻 Developed by: Shyama Hadia",
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 2, 46, 59),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
