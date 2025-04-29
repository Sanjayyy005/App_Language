import 'package:flutter/material.dart';
import '../modes/quiz.dart';
import '../services/api_service.dart';

class QuizProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Quiz> _quizzes = [];
  bool _isLoading = false;

  List<Quiz> get quizzes => _quizzes;
  bool get isLoading => _isLoading;

  Future<void> fetchQuizzes() async {
    try {
      _isLoading = true;
      notifyListeners();
      _quizzes = await _apiService.fetchQuizzes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error fetching quizzes: $e');
    }
  }
}