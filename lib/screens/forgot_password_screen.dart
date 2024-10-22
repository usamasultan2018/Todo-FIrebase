import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/backends/auth_service.dart';
import 'package:firebase_todo_app/backends/firebase_exception_handler.dart';
import 'package:firebase_todo_app/components/custom_textfield.dart';
import 'package:firebase_todo_app/components/rounded_button.dart';
import 'package:firebase_todo_app/screens/login_screen.dart';
import 'package:firebase_todo_app/utils/snackbar_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  Future<void> _sendResetEmail() async {
    // Check if the email field is empty
    if (_emailController.text.isEmpty) {
      SnackbarUtil.showErrorSnackbar(context, "Please enter your email");
      return; // Exit the function if the email is empty
    }

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // Send password reset email
      await _authService.sendPasswordResetEmail(_emailController.text.trim());

      // Show success snackbar
      SnackbarUtil.showSuccessSnackbar(context, "Password reset email sent!");

      // Navigate to the Login screen after a brief delay
      await Future.delayed(
          Duration(seconds: 1)); // Optional: delay for better UX
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) {
        return LoginScreen();
      }), (route) => false);
    } on FirebaseAuthException catch (e) {
      String errorMessage = FirebaseExceptionHandler.handleException(e);
      SnackbarUtil.showErrorSnackbar(context, errorMessage);
    } catch (e) {
      // Show error snackbar
      SnackbarUtil.showErrorSnackbar(context, "Error: $e");
    } finally {
      // Hide loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Reset Your Password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16), // Add space after the title
            const Text(
              "Enter your email address below, and we'll send you instructions to reset your password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 50), // Add space before the text field
            CustomTextField(
              controller: _emailController,
              hintText: "Email",
            ),
            const SizedBox(height: 30),
            RoundedButton(
              onPressed: _sendResetEmail,
              isLoading: _isLoading,
              text: "Send Reset Email",
            ),
          ],
        ),
      ),
    );
  }
}
