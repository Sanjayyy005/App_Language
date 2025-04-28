import 'package:flutter/material.dart';
import '../modes/lesson.dart';
import '../services/api_service.dart';

class LessonProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Lesson> _lessons = [];

  List<Lesson> get lessons => _lessons;

  Future<void> fetchLessons() async {
    try {
      _lessons = await _apiService.fetchLessons();
      notifyListeners();
    } catch (e) {
      print('Error fetching lessons: $e');
    }
  }
}