import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lesson_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/lesson_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Language Learning')),
      body: FutureBuilder(
        future: lessonProvider.fetchLessons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: lessonProvider.lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessonProvider.lessons[index];
              return LessonCard(
                lesson: lesson,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.lesson,
                    arguments: {'lessonId': lesson.id},
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}