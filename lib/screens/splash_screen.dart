import 'package:firebase_todo_app/screens/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after a delay
    Future.delayed(Duration(seconds: 3), () {
      // You can replace this with your navigation code
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AuthWrapper())); // Replace with your next screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SVG Logo
            SvgPicture.asset(
              'assets/todo_logo.svg', // Ensure your SVG file is in the assets directory
              height: 200, // Adjust size as needed
              width: 200, // Adjust size as needed
            ),
            Text(
              'Welcome to TodoList Pro', // Your welcome text
              style: TextStyle(
                fontSize: 24, // Adjust size as needed
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color
              ),
            ),
            const SizedBox(height: 10), // Space between text and below
            Text(
              'Organize Your Life, One Task at a Time', // Optional tagline
              style: TextStyle(
                fontSize: 16, // Adjust size as needed
                color: Colors.grey, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
