import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/backends/auth_service.dart';
import 'package:firebase_todo_app/backends/firebase_exception_handler.dart';
import 'package:firebase_todo_app/components/custom_textfield.dart';
import 'package:firebase_todo_app/components/rounded_button.dart';
import 'package:firebase_todo_app/screens/login_screen.dart';
import 'package:firebase_todo_app/utils/snackbar_util.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVissible = false;
  // loading variable ...........
  bool _loading = false;

  Future<void> _register() async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      SnackbarUtil.showErrorSnackbar(context, "Please fill all fields");
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      User? user = await _authService.signUp(
        emailController.text,
        passwordController.text,
        usernameController.text,
      );

      if (user != null) {
        // Clear the fields and show success message

        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        // ignore: use_build_context_synchronously
        SnackbarUtil.showSuccessSnackbar(context,
            "Please check your email!!");

        // Navigate to the login screen without popping the registration screen
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => const LoginScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      String errorMessage = FirebaseExceptionHandler.handleException(e);
      // ignore: use_build_context_synchronously
      SnackbarUtil.showErrorSnackbar(context, errorMessage);
    } catch (e) {
      // Handle any other general errors
      // ignore: use_build_context_synchronously
      SnackbarUtil.showErrorSnackbar(context, "An unexpected error occurred.");
    } finally {
      // Ensure that the loading indicator is stopped
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 80,
              ),

              const Center(child: Icon(Icons.lock, size: 100)),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Create an account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.9,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: usernameController,
                hintText: "Username",
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: emailController,
                hintText: "Email",
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: passwordController,
                hintText: "Password",
                isPassword: passwordVissible,
                prefixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      passwordVissible = !passwordVissible;
                    });
                  },
                  icon: Icon(
                    passwordVissible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              // Now login button
              RoundedButton(
                text: "Signup",
                onPressed: _register,
                isLoading: _loading,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const LoginScreen();
                      }));
                    },
                    child: const Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
