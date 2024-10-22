import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/backends/auth_service.dart';
import 'package:firebase_todo_app/backends/todos_service.dart';
import 'package:firebase_todo_app/components/drawer.dart';
import 'package:firebase_todo_app/components/loading_indicator.dart';

import 'package:firebase_todo_app/models/todo_model.dart';

import 'package:firebase_todo_app/screens/addtask_screen.dart';
import 'package:firebase_todo_app/screens/edit_task_screen.dart';
import 'package:firebase_todo_app/screens/login_screen.dart';
import 'package:firebase_todo_app/screens/profile_screen.dart';
import 'package:firebase_todo_app/utils/snackbar_util.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  TodoService todoService = TodoService();
  bool _isLoading = false;

  Future<void> logout() async {
    // Check if the user is logged in
    if (_auth.currentUser == null) {
      SnackbarUtil.showErrorSnackbar(context, "User is not logged in.");
      return; // Exit if there's no logged-in user
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await _authService.signOut(); // Sign out from the auth service

      // Navigate to the login screen
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) {
        return LoginScreen();
      }), (route) => false);

      SnackbarUtil.showSuccessSnackbar(context, "Logout Successfully");
    } catch (e) {
      SnackbarUtil.showErrorSnackbar(
          context, "Logout failed: $e"); // Show error message
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("H O M E"),
      ),
      backgroundColor: Colors.grey.shade200,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            return AddTaskScreen();
          }));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      drawer: MyDrawer(
          onLogoutTap: logout,
          onProfileTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) {
                return ProfileScreen();
              }),
            );
          }),
      body: StreamBuilder<List<TodoModel>>(
        stream: TodoService().getAllTodos(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator();
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No todos added yet!!"));
          } else {
            List<TodoModel> todos = snapshot.data;
            return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return EditTaskScreen(todoModel: todos[index]);
                      }));
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: double.infinity,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${todos[index].title}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Container(
                                      width:
                                          200, // Adjust this to control the text width
                                      child: Text(
                                        "${todos[index].description}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines:
                                            1, // Restrict the text to one line
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 0.5,
                                      width: 250,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${todos[index].createdAt}",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Checkbox(
                            activeColor: Colors.blue,
                            side: BorderSide(color: Colors.grey, width: 1.5),
                            checkColor: Colors.white,
                            splashRadius: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            value: todos[index].isCompleted,
                            onChanged: (value) async {
                              setState(() {
                                todos[index].isCompleted = value!;
                              });

                              // Update the Todo in Firebase
                              try {
                                await todoService.updateTodo(todos[index]);
                              } catch (e) {
                                // Handle the error, for example, show a Snackbar
                                SnackbarUtil.showErrorSnackbar(
                                    context, "Failed to update todo: $e");
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
