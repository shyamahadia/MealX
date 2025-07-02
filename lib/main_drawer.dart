import 'package:flutter/material.dart';
import 'package:my_recepi_app/about_us_screen.dart';
import 'package:my_recepi_app/favorites_screen.dart';
import 'package:my_recepi_app/recipe_model.dart';
import 'package:my_recepi_app/smart_recipe_screen.dart';
import 'package:my_recepi_app/views/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainDrawer extends StatelessWidget {
  final Function(String) onItemSelected;
  final List<Recipe> allRecipes;

  const MainDrawer({
    super.key,
    required this.onItemSelected,
    required this.allRecipes,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? "Guest";
    final userEmail = user?.email ?? "guest@gmail.com";
    final photoUrl = user?.photoURL;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 46, 59),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Profile()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.chat),
            title: Text("Smart Recipe Generator"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SmartRecipeScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Favorite Recipes"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.info),
            title: Text("About Us"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutUsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
