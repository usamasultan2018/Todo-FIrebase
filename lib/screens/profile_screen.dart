import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/backends/user_service.dart';
import 'package:firebase_todo_app/components/loading_indicator.dart';
import 'package:firebase_todo_app/models/usermodel.dart';
import 'package:firebase_todo_app/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var _auth = FirebaseAuth.instance;
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: StreamBuilder<UserModel?>(
              stream: UserService().streamUserData(_auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingIndicator();
                }
                if (!snapshot.hasData) {
                  return Center(child: Text("No user Data"));
                } else {
                  UserModel userModel = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login Information",
                        style: TextStyle(),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              color: Colors.black54,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Username",
                              style: TextStyle(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Center(
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.grey
                                            .shade300, // Fallback background
                                        child: userModel
                                                .profilePicture.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    userModel.profilePicture,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    SizedBox(
                                                  height: 10,
                                                  child: LoadingIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(
                                                  Icons.no_photography_outlined,
                                                  size: 50,
                                                  color: Colors.grey.shade600,
                                                ),
                                              )
                                            : Icon(
                                                Icons
                                                    .person, // Default icon if no profile picture
                                                size: 50,
                                                color: Colors.grey.shade600,
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${userModel.username}",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (ctx) {
                                        return EditProfileScreen(
                                          userModel: userModel,
                                        );
                                      }));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Connected Account",
                              style: TextStyle(),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 17,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "${userModel.email}",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Registered on",
                              style: TextStyle(),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 17,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "${userModel.createdAt}",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
        ));
  }
}
