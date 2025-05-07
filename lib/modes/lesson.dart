class Lesson {
  final int id;
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
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      audioUrl: json['audioUrl'] as String,
    );
  }

  @override
  String toString() {
    return 'Lesson(id: $id, title: $title)';
  }
}