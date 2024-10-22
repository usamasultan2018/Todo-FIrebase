import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/models/todo_model.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> addTodo(TodoModel todoModel) async {
    try {
      DocumentReference docRef =
          await _firestore.collection("todos").add(todoModel.toMap());
      await _firestore.collection("todos").doc(docRef.id).update({
        "id": docRef.id,
      });
    } catch (e) {
      throw Exception("Error adding todo: $e");
    }
  }

  Stream<List<TodoModel>> getAllTodos() {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      // Return an empty stream if the user is not logged in
      return Stream.value([]);
    }

    // Proceed if user is logged in
    return _firestore
        .collection("todos")
        .where("userId", isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TodoModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> updateTodo(TodoModel todo) async {
    try {
      await _firestore.collection('todos').doc(todo.id).update(todo.toMap());
    } catch (e) {
      throw Exception("Error updating todo: $e");
    }
  }

  // Future<TodoModel?> getTodoById(String todoId) async {
  //   try {
  //     DocumentSnapshot doc =
  //         await _firestore.collection('todos').doc(todoId).get();
  //     if (doc.exists) {
  //       return TodoModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception("Error fetching todo: $e");
  //   }
  // }

  Future<void> deleteTodo(String todoId) async {
    try {
      await _firestore.collection('todos').doc(todoId).delete();
    } catch (e) {
      throw Exception("Error deleting todo: $e");
    }
  }
}
