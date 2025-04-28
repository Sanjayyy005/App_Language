class UserProgress {
  final String userId;
  final List<String> completedLessons;
  final List<String> completedQuizzes;
  final int score;

  UserProgress({
    required this.userId,
    required this.completedLessons,
    required this.completedQuizzes,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'completedLessons': completedLessons,
      'completedQuizzes': completedQuizzes,
      'score': score,
    };
  }

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      userId: map['userId'],
      completedLessons: List<String>.from(map['completedLessons']),
      completedQuizzes: List<String>.from(map['completedQuizzes']),
      score: map['score'],
    );
  }
}