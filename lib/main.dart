import 'package:flutter/material.dart';
import 'package:my_recepi_app/home.dart';
import 'package:my_recepi_app/views/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_recepi_app/localdb.dart';
import 'package:my_recepi_app/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const Color primaryColor = Color.fromARGB(255, 2, 78, 101);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Listen for auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        // User signed in, load local data then update state
        Constant.name =
            (await LocalDataSaver.getName()) ?? user.displayName ?? "";
        Constant.email = (await LocalDataSaver.getEmail()) ?? user.email ?? "";
        Constant.img = (await LocalDataSaver.getImg()) ?? user.photoURL ?? "";

        setState(() {
          this.user = user;
          isLoading = false;
        });
      } else {
        // User signed out
        setState(() {
          this.user = null;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show loading while checking auth state
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (user == null) {
      // Not signed in
      return const Login();
    } else {
      // Signed in
      return const Home();
    }
  }
}
