import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/feature/questions/entity%20/question_answer_entity.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_card.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.questionNumber,
    required this.totalQuestions,
    required this.question,
  });

  final int questionNumber;
  final int totalQuestions;
  final QuestionAnswerEntity question;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Question $questionNumber of $totalQuestions',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Text(
                question.difficulty,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question.question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
