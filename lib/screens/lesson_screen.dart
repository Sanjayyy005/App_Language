import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modes/lesson.dart';
import '../providers/lesson_provider.dart';

class LessonScreen extends StatefulWidget {
  final int lessonId;

  const LessonScreen({super.key, required this.lessonId});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
      if (lessonProvider.lessons.isEmpty) {
        lessonProvider.fetchLessons();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Find the lesson, with a fallback if not found
        final lesson = provider.lessons.firstWhere(
              (l) => l.id == widget.lessonId,
          orElse: () => Lesson(id: -1, title: '', content: '', audioUrl: ''),
        );

        // Check if the lesson was not found
        if (lesson.id == -1) {
          return Scaffold(
            appBar: AppBar(title: const Text('Lesson')),
            body: const Center(child: Text('Lesson not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(lesson.title)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(lesson.content),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add audio playback logic here
                  },
                  child: const Text('Play Audio'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}