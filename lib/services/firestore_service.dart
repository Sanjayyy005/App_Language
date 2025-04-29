import 'package:cloud_firestore/cloud_firestore.dart';
import '../modes/user_progress.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserProgress(UserProgress progress) async {
    try {
      await _db
          .collection('user_progress')
          .doc(progress.userId)
          .set(progress.toMap());
    } catch (e) {
      throw Exception('Failed to save user progress: $e');
    }
  }

  Future<UserProgress?> getUserProgress(String userId) async {
    try {
      DocumentSnapshot doc =
      await _db.collection('user_progress').doc(userId).get();
      if (doc.exists) {
        return UserProgress.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user progress: $e');
    }
  }
}