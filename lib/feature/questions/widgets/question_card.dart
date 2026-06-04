import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_card.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key, required this.questionNumber, required this.totalQuestions, required this.question});

  final int questionNumber;
  final int totalQuestions;
  final String question;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Question $questionNumber of $totalQuestions', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Text(question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
