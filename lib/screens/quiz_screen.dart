import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modes/quiz.dart';
import '../modes/user_progress.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../services/firestore_service.dart';
import '../widgets/quiz_question.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;

  const QuizScreen({super.key, required this.quizId});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      if (quizProvider.quizzes.isEmpty) {
        quizProvider.fetchQuizzes();
      }
    });
  }

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

          // Find the quiz, with a fallback if not found
          final quiz = provider.quizzes.firstWhere(
                (q) => q.id.toString() == widget.quizId,
            orElse: () => Quiz(
              id: -1,
              question: 'Quiz not found',
              options: [],
              correctAnswer: '',
            ),
          );

          // Check if the quiz was not found
          if (quiz.id == -1) {
            return const Center(child: Text('Quiz not found'));
          }

          return QuizQuestion(
            quiz: quiz,
            onAnswer: (isCorrect) async {
              if (isCorrect && authProvider.userId != null) {
                try {
                  UserProgress? existingProgress =
                  await firestoreService.getUserProgress(authProvider.userId!);
                  List<String> completedQuizzes =
                      existingProgress?.completedQuizzes ?? [];

                  if (!completedQuizzes.contains(widget.quizId)) {
                    completedQuizzes.add(widget.quizId);
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