import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_recepi_app/constant.dart';
import 'package:my_recepi_app/views/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final String name = Constant.name.isNotEmpty ? Constant.name : "No Name";
    final String email =
        Constant.email.isNotEmpty ? Constant.email : "No Email";
    final String imgUrl = Constant.img;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 210, 226, 242),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 46, 59),
        title: const Text(
          "Profile Page",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage:
                    imgUrl.isNotEmpty ? NetworkImage(imgUrl) : null,
                child:
                    imgUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
              ),
              SizedBox(height: 6),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 2, 46, 59),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              Text(
                email,
                style: const TextStyle(
                  color: Color.fromARGB(255, 2, 46, 59),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 440),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Login()),
                      (route) => false,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 2, 46, 59),
                        size: 19,
                      ),
                      const Text(
                        'Logout',
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 46, 59),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
