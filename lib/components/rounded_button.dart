import 'package:firebase_todo_app/components/loading_indicator.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(double.infinity, 50), // Full width, 50 height
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white), // Text color
        backgroundColor:
            MaterialStateProperty.all(Colors.blueAccent), // Button color
      ),
      onPressed: isLoading ? null : onPressed, // Disable when loading
      child: isLoading
          ? LoadingIndicator()
          : Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ), // Display button text
    );
  }
}
