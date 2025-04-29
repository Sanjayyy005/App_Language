import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modes/quiz.dart';
import '../modes/user_progress.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../services/firestore_service.dart';
import '../widgets/quiz_question.dart';

class QuizScreen extends StatelessWidget {
  final String quizId;

  const QuizScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final quiz = provider.quizzes.firstWhere(
                (q) => q.id == quizId,
            orElse: () => Quiz(
              id: '',
              question: 'Quiz not found',
              options: [],
              correctAnswer: '',
            ),
          );
          return QuizQuestion(
            quiz: quiz,
            onAnswer: (isCorrect) async {
              if (isCorrect && authProvider.userId != null) {
                try {
                  UserProgress? existingProgress =
                  await firestoreService.getUserProgress(authProvider.userId!);
                  List<String> completedQuizzes =
                      existingProgress?.completedQuizzes ?? [];

                  if (!completedQuizzes.contains(quizId)) {
                    completedQuizzes.add(quizId);
                  }

                  final progress = UserProgress(
                    userId: authProvider.userId!,
                    completedLessons: existingProgress?.completedLessons ?? [],
                    completedQuizzes: completedQuizzes,
                    score: (existingProgress?.score ?? 0) + 20,
                  );

                  await firestoreService.saveUserProgress(progress);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quiz completed! +20 points')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving progress: $e')),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}