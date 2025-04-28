import 'package:flutter/material.dart';
import '../modes/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const LessonCard({super.key, required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(lesson.title),
        subtitle: Text(lesson.content),
        onTap: onTap,
      ),
    );
  }
}