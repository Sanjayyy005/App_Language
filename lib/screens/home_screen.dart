import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/lesson_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/lesson_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch lessons when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LessonProvider>(context, listen: false).fetchLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Learning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.quiz,
                  arguments: {'quizId': '1'},
                );
              },
              child: const Text('Take a Quiz'),
            ),
          ),
          Expanded(
            child: Consumer<LessonProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.lessons.isEmpty) {
                  return const Center(
                    child: Text(
                      'No lessons available. Check API connection.',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: provider.lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = provider.lessons[index];
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
          ),
        ],
      ),
    );
  }
}