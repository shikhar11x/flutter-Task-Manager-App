import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Tasks collection
  CollectionReference get _tasks => _db.collection('tasks');

  // Add Task
  Future<void> addTask(Task task) async {
    await _tasks.add(task.toMap());
  }

  // Get Tasks (sirf us user ki)
  Stream<List<Task>> getTasks(String userId) {
    return _tasks
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Update Task
  Future<void> updateTask(Task task) async {
    await _tasks.doc(task.id).update(task.toMap());
  }

  // Delete Task
  Future<void> deleteTask(String taskId) async {
    await _tasks.doc(taskId).delete();
  }

  // Toggle Complete
  Future<void> toggleComplete(String taskId, bool current) async {
    await _tasks.doc(taskId).update({'isCompleted': !current});
  }
}