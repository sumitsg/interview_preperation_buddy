import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/gemini_service.dart';
import '../bloc/interview_bloc.dart';
import '../bloc/interview_state.dart';

class InterviewPage extends StatelessWidget {
  const InterviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview'),
      ),
      body: BlocBuilder<
          InterviewBloc,
          InterviewState>(
        builder: (context, state) {

          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.questions.isEmpty) {
            return const Center(
              child: Text(
                'No questions available',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.questions.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final question =
              state.questions[index];

              return Card(
                child: Padding(
                  padding:
                  const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Question ${state.currentQuestionIndex + 1}/5',
                      ),

                      const SizedBox(height: 8),

                      Chip(
                        label: Text(
                          question.difficulty.toUpperCase(),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Recommended Time: '
                            '${formatTime(question.expectedTimeSeconds)}',
                      ),

                      const SizedBox(height: 16),

                      Text(question.question),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}