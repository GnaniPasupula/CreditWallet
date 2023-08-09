import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: SignInScreen(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  Future<void> _handleSignIn(BuildContext context) async {
    try {
      UserCredential userCredential = await signInWithGoogle();
      print("Signed in with Google: ${userCredential.user?.displayName}");
      // Navigate to a new screen or perform actions after successful sign-in
    } catch (error) {
      print("Error during Google Sign-In: $error");
      // Handle the error, show a snackbar, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleSignIn(context),
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}
