import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modes/lesson.dart';
import '../modes/quiz.dart';

class ApiService {
  final String baseUrl = 'https://my-json-server.typicode.com/<your-username>/language-learning';

  Future<List<Lesson>> fetchLessons() async {
    final response = await http.get(Uri.parse('$baseUrl/lessons'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Lesson.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }

  Future<List<Quiz>> fetchQuizzes() async {
    final response = await http.get(Uri.parse('$baseUrl/quizzes'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Quiz.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }
}