class Lesson {
  final String id;
  final String title;
  final String content;
  final String audioUrl;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.audioUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'].toString(),
      title: json['title'],
      content: json['content'],
      audioUrl: json['audioUrl'],
    );
  }
}