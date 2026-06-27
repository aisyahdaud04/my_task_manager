import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  // Convert Firestore document to Task object
  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert Task to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}