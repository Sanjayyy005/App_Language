import 'package:cloud_firestore/cloud_firestore.dart';
import '../modes/quiz.dart';

Future<List<Quiz>> getQuizzes() async {
  try {
    QuerySnapshot snapshot = await _db.collection('quizzes').get();
    return snapshot.docs.map((doc) {
      return Quiz(
        id: doc.id,
        question: doc['question'],
        options: List<String>.from(doc['options']),
        correctAnswer: doc['correctAnswer'],
      );
    }).toList();
  } catch (e) {
    throw Exception('Failed to fetch quizzes: $e');
  }
}