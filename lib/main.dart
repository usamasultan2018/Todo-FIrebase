import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_todo_app/firebase_options.dart';
import 'package:firebase_todo_app/screens/auth_wrapper.dart';
import 'package:firebase_todo_app/screens/introduction_screen.dart';
import 'package:firebase_todo_app/screens/splash_screen.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo App',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
