import 'dart:io';
import 'package:firebase_todo_app/backends/user_service.dart';
import 'package:firebase_todo_app/components/custom_textfield.dart';
import 'package:firebase_todo_app/components/rounded_button.dart';
import 'package:firebase_todo_app/models/usermodel.dart';
import 'package:firebase_todo_app/utils/image_picker.dart';
import 'package:firebase_todo_app/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const EditProfileScreen({super.key, required this.userModel});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController usernameController = TextEditingController();
  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.userModel.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor:
                      Colors.grey.shade300, // Background color fallback
                  child: selectedImage != null
                      ? ClipOval(
                          child: Image.file(
                            selectedImage!, // Display selected local image
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        )
                      : widget.userModel.profilePicture.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.userModel
                                  .profilePicture, // Load profile picture
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(), // Loading indicator
                              errorWidget: (context, url, error) => const Icon(
                                Icons
                                    .no_photography_outlined, // Show icon if image loading fails
                                size: 50,
                                color: Colors.grey,
                              ),
                            )
                          : Icon(
                              Icons.person, // Fallback person icon
                              size: 50,
                              color: Colors.grey.shade600,
                            ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: InkWell(
                    onTap: pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.tertiary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.grey.shade300,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: usernameController,
              hintText: "Enter your username",
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            RoundedButton(
              isLoading: isLoading,
              text: "Update Profile",
              onPressed: uploadProfilePictureAndUpdate,
            ),
          ],
        ),
      ),
    );
  }

  // Image picking function
Future<void> pickImage() async {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 150,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () async {
                Navigator.pop(context); // Close the bottom sheet
                File? image = await CustomImagePicker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    selectedImage = image;
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Gallery'),
              onTap: () async {
                Navigator.pop(context); // Close the bottom sheet
                File? image = await CustomImagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    selectedImage = image;
                  });
                }
              },
            ),
          ],
        ),
      );
    },
  );
}


  // Function to upload profile picture and update user data
  Future<void> uploadProfilePictureAndUpdate() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      String profilePicUrl = widget.userModel.profilePicture;

      // If a new image is selected, upload and get the new URL
      if (selectedImage != null) {
        profilePicUrl = await UserService().uploadProfilePicture(
              selectedImage!,
              widget.userModel.id,
            ) ??
            profilePicUrl; // Fallback to old picture if upload fails
      }

      // Update user data with the new or old profile picture
      UserModel updatedUser = UserModel(
        id: widget.userModel.id,
        username: usernameController.text,
        email: widget.userModel.email,
        profilePicture: profilePicUrl,
        createdAt: widget.userModel.createdAt,
      );

      await UserService().updateUserData(updatedUser);

      // Optionally, show a success message
      SnackbarUtil.showSuccessSnackbar(context, "Profile updated successfully");

      Navigator.pop(context); // Close the screen after update
    } catch (e) {
      // Show error message if update fails
      SnackbarUtil.showErrorSnackbar(context, 'Error updating profile: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }
}
