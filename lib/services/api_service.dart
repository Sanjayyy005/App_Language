import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modes/lesson.dart';
import '../modes/quiz.dart';

class ApiService {
  final String baseUrl = 'http://192.168.42.239:3001';

  Future<List<Lesson>> fetchLessons() async {
    try {
      print('Fetching lessons from $baseUrl/lessons');
      final response = await http.get(Uri.parse('$baseUrl/lessons'));
      print('Response status: ${response.statusCode}, body: ${response.body}');
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Lesson.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load lessons: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching lessons: $e');
      throw Exception('Error fetching lessons: $e');
    }
  }

  Future<List<Quiz>> fetchQuizzes() async {
    try {
      print('Fetching quizzes from $baseUrl/quizzes');
      final response = await http.get(Uri.parse('$baseUrl/quizzes'));
      print('Response status: ${response.statusCode}, body: ${response.body}');
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Quiz.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load quizzes: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching quizzes: $e');
      throw Exception('Error fetching quizzes: $e');
    }
  }
}