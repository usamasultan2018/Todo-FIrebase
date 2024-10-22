import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart'; // For debugPrint

class CustomImagePicker {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage({required ImageSource source}) async {
    File? image;
    try {
      // Pick a single image
      final XFile? pickFile =
          await _picker.pickImage(source: source);

      if (pickFile != null) {
        image = File(pickFile.path);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return image;
  }
}
