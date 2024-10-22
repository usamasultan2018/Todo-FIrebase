import 'dart:convert';

class TodoModel {
  String userId;
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;

  TodoModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  // Convert TodoModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a TodoModel from Firestore data
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      userId: map['userId'],
      id: map["id"],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
