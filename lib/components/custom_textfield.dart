import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final bool isPassword;
  final IconButton? prefixIcon; // Optional prefix icon

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.prefixIcon,
    this.maxLines = 1, // Initialize the prefixIcon parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines, //  1
      controller: controller,
      obscureText: isPassword, // Show/hide password
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        suffixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(10.0), // Padding around the icon
                child: prefixIcon, // Display the icon
              )
            : null, // If no icon is provided, use null
      ),
    );
  }
}
