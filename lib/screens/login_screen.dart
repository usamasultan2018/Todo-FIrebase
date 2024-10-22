import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/backends/auth_service.dart';
import 'package:firebase_todo_app/backends/firebase_exception_handler.dart';
import 'package:firebase_todo_app/components/custom_textfield.dart';
import 'package:firebase_todo_app/components/rounded_button.dart';
import 'package:firebase_todo_app/screens/forgot_password_screen.dart';
import 'package:firebase_todo_app/screens/home_screen.dart';
import 'package:firebase_todo_app/screens/register_screen.dart';
import 'package:firebase_todo_app/utils/snackbar_util.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService _authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isPasswordVissible = true;
  bool _isLoading = false;

  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      SnackbarUtil.showErrorSnackbar(context, "Please fill all fields");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the signIn method which can throw exceptions
      User? user = await _authService.signIn(
        emailController.text,
        passwordController.text,
      );
      if (!user!.emailVerified) {
        SnackbarUtil.showErrorSnackbar(context, "Please verifed your email");
      }

      if (user != null && user.emailVerified) {
        // Navigate to home screen on successful login
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) {
          return HomeScreen();
        }), (route) => false);
        SnackbarUtil.showSuccessSnackbar(context, "Login Successful!");
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      String errorMessage = FirebaseExceptionHandler.handleException(e);
      SnackbarUtil.showErrorSnackbar(context, errorMessage);
    } catch (e) {
      // Handle any other general errors
      SnackbarUtil.showErrorSnackbar(context, "An unexpected error occurred.");
    } finally {
      // Ensure that the loading indicator is stopped
      setState(() {
        _isLoading = false;
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
              SizedBox(
                height: 80,
              ),
              Center(child: Icon(Icons.lock, size: 100)),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Welcome back, you've been missed!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.9,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              // email textfield custom
              CustomTextField(
                controller: emailController,
                hintText: "Email",
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: passwordController,
                hintText: "Password",
                isPassword: _isPasswordVissible,
                prefixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVissible = !_isPasswordVissible;
                    });
                  },
                  icon: Icon(_isPasswordVissible
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),

              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return ForgotPasswordScreen();
                      }));
                    },
                    child: Text("Forgot password")),
              ),

              SizedBox(
                height: 20,
              ),

              // login button..
              RoundedButton(
                isLoading: _isLoading,
                text: "Login",
                onPressed: _login,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dont have an account?",
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return RegisterScreen();
                        }));
                      },
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
