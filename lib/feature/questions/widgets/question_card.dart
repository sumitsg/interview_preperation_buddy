import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_bloc.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_card.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final questionState = context.select(
      (InterviewQuestionBloc bloc) => bloc.state,
    );

    if (questionState.currentQuestion == null) {
      return const SizedBox.shrink();
    }

    final question = questionState.currentQuestion!;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Question ${questionState.currentQuestionNumber} of ${questionState.totalQuestions}',
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
