import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_todo_app/models/usermodel.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw e; // Handle the exception as necessary
    }
  }

  // Stream user data
  Stream<UserModel?> streamUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        return null; // Return null if user does not exist
      }
    });
  }

  // Update user data
  Future<void> updateUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.id)
          .update(userModel.toJson());
      print('User data updated successfully for ${userModel.email}');
    } catch (e) {
      print('Error updating user data: $e');
      throw e; // Handle the exception as necessary
    }
  }

  // Delete user data
  Future<void> deleteUserData(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      print('User data deleted successfully for UID: $uid');
    } catch (e) {
      print('Error deleting user data: $e');
      throw e; // Handle the exception as necessary
    }
  }

  // Upload picture to storage ..
  // Function to upload profile picture
  Future<String?> uploadProfilePicture(File imageFile, String userId) async {
    try {
      // Define the path in Firebase Storage where the profile picture will be stored
      String filePath =
          "profile_pics/$userId/${DateTime.now().millisecondsSinceEpoch}.png";

      // Upload the image file to Firebase Storage
      UploadTask uploadTask = _storage.ref().child(filePath).putFile(imageFile);

      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;

      // Retrieve the download URL from Firebase Storage
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // Log any errors that occur during the upload
      print("Error uploading profile picture: $e");
      return null; // Return null in case of any errors
    }
  }
}
