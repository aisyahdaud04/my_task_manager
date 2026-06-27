import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's task collection reference
  CollectionReference get _tasksCollection {
    String uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('tasks');
  }

  // Create a new task
  Future<void> createTask(String title, String description) async {
    await _tasksCollection.add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Read all tasks for current user
  Stream<List<Task>> getTasks() {
    return _tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromFirestore(doc);
      }).toList();
    });
  }

  // Update a task
  Future<void> updateTask(String taskId, String title, String description) async {
    await _tasksCollection.doc(taskId).update({
      'title': title,
      'description': description,
    });
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }
}