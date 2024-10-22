import 'package:flutter/material.dart';

class SnackbarUtil {
  static void showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(message, style: TextStyle(color: Colors.white)),
      showCloseIcon: true,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccessSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.greenAccent,
      content: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
      showCloseIcon: true,
      closeIconColor: Colors.black,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
