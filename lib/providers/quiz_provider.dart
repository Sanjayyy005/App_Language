import 'package:flutter/material.dart';
import '../modes/quiz.dart';
import '../services/firestore_service.dart';

class QuizProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Quiz> _quizzes = [];
  bool _isLoading = false;

  List<Quiz> get quizzes => _quizzes;
  bool get isLoading => _isLoading;

  Future<void> fetchQuizzes() async {
    try {
      _isLoading = true;
      notifyListeners();

      _quizzes = await _firestoreService.getQuizzes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error fetching quizzes: $e');
      throw Exception('Failed to fetch quizzes: $e');
    }
  }
}