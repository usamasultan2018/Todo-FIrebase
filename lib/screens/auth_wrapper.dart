import 'package:firebase_todo_app/components/loading_indicator.dart';
import 'package:firebase_todo_app/screens/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the Firebase authentication state
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        }
        if (snapshot.hasData) {
          User? user = snapshot.data;

          // Check if the user exists and their email is verified
          if (user != null && user.emailVerified) {
            return HomeScreen(); // Proceed to home screen if verified
          } else {
            return IntroductionScreen(); // If not verified, show login screen
          }
        } else {
          return IntroductionScreen(); // Show login screen if not authenticated
        }
      },
    );
  }
}
