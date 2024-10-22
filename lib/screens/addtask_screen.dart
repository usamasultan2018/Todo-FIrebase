import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/backends/todos_service.dart';
import 'package:firebase_todo_app/components/custom_textfield.dart';
import 'package:firebase_todo_app/components/rounded_button.dart';
import 'package:firebase_todo_app/models/todo_model.dart';
import 'package:firebase_todo_app/utils/snackbar_util.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TodoService todoService = TodoService();
  bool _isLoading = false;

  Future<void> addTask() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      SnackbarUtil.showErrorSnackbar(context, "Please fill the fields");
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      TodoModel todoModel = TodoModel(
        userId: _firebaseAuth.currentUser!.uid,
        id: "",
        title: titleController.text,
        description: descriptionController.text,
        isCompleted: false,
        createdAt: DateTime.now(),
      );
      await todoService.addTodo(todoModel);
      titleController.clear();
      descriptionController.clear();
      setState(() {
        _isLoading = false;
      });
      SnackbarUtil.showSuccessSnackbar(context, "Task Added");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
      SnackbarUtil.showErrorSnackbar(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Task"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add a todo task",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: titleController,
                hintText: "Title",
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                maxLines: 4,
                controller: descriptionController,
                hintText: "Description",
              ),
              SizedBox(
                height: 20,
              ),
              RoundedButton(
                isLoading: _isLoading,
                text: "Add Task",
                onPressed: addTask,
              ),
            ],
          ),
        ));
  }
}
