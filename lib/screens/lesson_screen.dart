import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modes/lesson.dart';
import '../modes/user_progress.dart';
import '../providers/auth_provider.dart';
import '../providers/lesson_provider.dart';
import '../services/firestore_service.dart';

class LessonScreen extends StatefulWidget {
  final String lessonId;

  const LessonScreen({super.key, required this.lessonId});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreService = FirestoreService();

    final lesson = lessonProvider.lessons.firstWhere(
          (l) => l.id == widget.lessonId,
      orElse: () => Lesson(
        id: '',
        title: 'Lesson Not Found',
        content: 'The requested lesson could not be found.',
        audioUrl: '',
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              lesson.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (lesson.audioUrl.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    if (_isAudioPlaying) {
                      await _audioPlayer.pause();
                      setState(() => _isAudioPlaying = false);
                    } else {
                      await _audioPlayer.play(UrlSource(lesson.audioUrl));
                      setState(() => _isAudioPlaying = true);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error playing audio: $e')),
                    );
                  }
                },
                icon: Icon(_isAudioPlaying ? Icons.pause : Icons.play_arrow),
                label: Text(_isAudioPlaying ? 'Pause Audio' : 'Play Audio'),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final userId = authProvider.userId;
                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please log in to save progress')),
                  );
                  return;
                }

                try {
                  UserProgress? existingProgress =
                  await firestoreService.getUserProgress(userId);
                  List<String> completedLessons =
                      existingProgress?.completedLessons ?? [];

                  if (!completedLessons.contains(widget.lessonId)) {
                    completedLessons.add(widget.lessonId);
                  }

                  final progress = UserProgress(
                    userId: userId,
                    completedLessons: completedLessons,
                    completedQuizzes: existingProgress?.completedQuizzes ?? [],
                    score: (existingProgress?.score ?? 0) + 10,
                  );

                  await firestoreService.saveUserProgress(progress);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lesson completed! +10 points')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving progress: $e')),
                  );
                }
              },
              child: const Text('Mark as Completed'),
            ),
          ],
        ),
      ),
    );
  }
}