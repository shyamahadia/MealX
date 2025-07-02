import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_recepi_app/localdb.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User?> signinWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount == null) {
      print("❌ Google Sign-In aborted by user");
      return null;
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );

    final User? user = userCredential.user;
    

    if (user == null) {
      print("❌ Firebase user is null after sign-in");
      return null;
    }

    // Save user data locally
    await LocalDataSaver.saveName(user.displayName ?? "");
    await LocalDataSaver.saveEmail(user.email ?? "");
    await LocalDataSaver.saveImg(user.photoURL ?? "");

    print("✅ Google Sign-In successful: ${user.displayName}, ${user.email}");
    return user;
  } catch (e) {
    print("❌ Error during Google Sign-In: $e");
    return null;
  }
}
