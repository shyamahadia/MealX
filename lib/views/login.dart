import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:my_recepi_app/constant.dart';
import 'package:my_recepi_app/services/auth.dart';
import 'package:my_recepi_app/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;

  Future<void> signInMethod(BuildContext context) async {
    setState(() => isLoading = true);

    final user = await signinWithGoogle(); // returns null if cancelled
    if (user == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Sign-in cancelled or failed")));
      return;
    }

    // Ensure data is saved before you try to fetch it
    // await LocalDataSaver.saveName(user.displayName ?? '');
    //await LocalDataSaver.saveEmail(user.email ?? '');
    // await LocalDataSaver.saveImg(user.photoURL ?? '');
    //Constant.name = (await LocalDataSaver.getName()) ?? "";
    // Constant.email = (await LocalDataSaver.getEmail()) ?? "";
    // Constant.img = (await LocalDataSaver.getImg()) ?? "";

    Constant.name = user.displayName ?? '';
    Constant.email = user.email ?? '';
    Constant.img = user.photoURL ?? '';

    print(
      "LOGIN → name=${Constant.name}, email=${Constant.email}, img=${Constant.img}",
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 210, 226, 242),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 46, 59),

        title: Text(
          "Login to App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child:
            isLoading
                ? CircularProgressIndicator(
                  color: const Color.fromARGB(255, 2, 46, 59),
                )
                : Column(
                  spacing: 80.2,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Image.asset("assets/images/chef.png"),

                    SizedBox(
                      width: 220,
                      height: 50,
                      child: SignInButton(
                        Buttons.Google,
                        onPressed: () => signInMethod(context),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
