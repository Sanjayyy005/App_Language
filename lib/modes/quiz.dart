class Quiz {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;

  Quiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'].toString(),
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
    );
  }
}