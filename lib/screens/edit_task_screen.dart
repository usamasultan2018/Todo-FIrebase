import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/backends/todos_service.dart';
import 'package:firebase_todo_app/components/custom_textfield.dart';
import 'package:firebase_todo_app/components/rounded_button.dart';
import 'package:firebase_todo_app/models/todo_model.dart';
import 'package:firebase_todo_app/utils/snackbar_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  final TodoModel todoModel;
  const EditTaskScreen({super.key, required this.todoModel});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TodoService todoService = TodoService();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.todoModel.title;
    _descriptionController.text = widget.todoModel.description;
  }

  Future<void> updateTask() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      SnackbarUtil.showErrorSnackbar(context, "Please fill the fields");
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      TodoModel todoModel = TodoModel(
        userId:widget.todoModel.userId,
        id: widget.todoModel.id,
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: false,
        createdAt: DateTime.now(),
      );
      await todoService.updateTodo(todoModel);
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
      SnackbarUtil.showSuccessSnackbar(context, "Task Updated");
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

  Future<void> deleteTask() async {
    try {
      await todoService.deleteTodo(widget.todoModel.id);
      SnackbarUtil.showSuccessSnackbar(context, "Task Deleled");
      Navigator.of(context).pop();
    } catch (e) {
      SnackbarUtil.showErrorSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task"),
        actions: [
          IconButton(
            onPressed:deleteTask,
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Edit a todo task",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: _titleController,
              hintText: "Title",
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              maxLines: 4,
              controller: _descriptionController,
              hintText: "Description",
            ),
            SizedBox(
              height: 20,
            ),
            RoundedButton(
              isLoading: _isLoading,
              text: "Update Task",
              onPressed: updateTask,
            ),
          ],
        ),
      ),
    );
  }
}
