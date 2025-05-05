import 'package:flutter/material.dart';
import '../modes/lesson.dart';
import '../services/api_service.dart';

class LessonProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Lesson> _lessons = [];
  bool _isLoading = false;

  List<Lesson> get lessons => _lessons;
  bool get isLoading => _isLoading;

  Future<void> fetchLessons() async {
    try {
      _isLoading = true;
      notifyListeners();
      _lessons = await _apiService.fetchLessons();
      print('Fetched lessons: $_lessons');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error fetching lessons: $e');
    }
    }
  }
