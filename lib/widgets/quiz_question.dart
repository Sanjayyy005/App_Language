import 'package:flutter/material.dart';
import '../modes/quiz.dart';

class QuizQuestion extends StatefulWidget {
  final Quiz quiz;
  final Function(bool) onAnswer;

  const QuizQuestion({super.key, required this.quiz, required this.onAnswer});

  @override
  _QuizQuestionState createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> {
  String? selectedAnswer;
  bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.quiz.question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...widget.quiz.options.map((option) => RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: selectedAnswer,
            onChanged: (value) {
              setState(() {
                selectedAnswer = value;
                isCorrect = value == widget.quiz.correctAnswer;
                widget.onAnswer(isCorrect!);
              });
            },
          )),
          if (selectedAnswer != null)
            Text(
              isCorrect! ? 'Correct!' : 'Incorrect. Try again!',
              style: TextStyle(
                color: isCorrect! ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}