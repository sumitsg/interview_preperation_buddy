import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/app/routes/app_routes.dart';
import 'package:interview_preperation_buddy/app/themes/app_colors.dart';

import 'package:interview_preperation_buddy/feature/feedback/controller/bloc/interview_evaluation_bloc.dart';
import 'package:interview_preperation_buddy/feature/feedback/controller/bloc/interview_evaluation_event.dart';
import 'package:interview_preperation_buddy/feature/feedback/controller/bloc/interview_evaluation_state.dart';

import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/competencies_card.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/detailed_insight_section.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/evaluation_action_button.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/evaluation_header.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/evaluation_score_card.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/executive_summary_card.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/focus_area_widget.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/interview_setup_header.dart';
import 'package:interview_preperation_buddy/feature/questions/entity/question_answer_entity.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_snackbar.dart';
import 'package:interview_preperation_buddy/shared/widgets/responsive_container.dart';

class EvaluationPage extends StatefulWidget {
  EvaluationPage({super.key, required this.args});

  //
  EvaluationPageArgs args;

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  @override
  void initState() {
    super.initState();

    const testJson = '''
{
  "questions": [
    {
      "id": 1,
      "question": "Explain StatelessWidget vs StatefulWidget in Flutter.",
      "answer": "StatelessWidget is immutable and used when UI does not change."
    },
    {
      "id": 2,
      "question": "What is BuildContext in Flutter?",
      "answer": "Used to locate widgets in widget tree."
    },
    {
      "id": 3,
      "question": "How would you build a list UI in Flutter?",
      "answer": "Using Row, Column and ListView."
    },
    {
      "id": 4,
      "question": "How do you fetch API data in Flutter?",
      "answer": ""
    },
    {
      "id": 5,
      "question": "How navigation works in Flutter?",
      "answer": "Navigator.push and pop."
    }
  ]
}
''';

    final List<Map<String, dynamic>> payload = widget.args.questionAndAnswer.map((e) => e.toJson()).toList();

    // log('Payload for Evaluation: $payload');

    log(jsonEncode(payload));

    context.read<EvaluateInterviewBloc>().add(
      EvaluateInterview(
        technology: widget.args.technology,
        experience: widget.args.experience,
        questionAndAnswer: payload.toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 800),
          child: Column(
            children: [
              // common Appbar
              const InterviewSetupHeader(),

              //
              Expanded(
                child: SingleChildScrollView(
                  child: BlocConsumer<EvaluateInterviewBloc, EvaluateInterviewState>(
                    listener: (context, state) {
                      if (state.evaluation == null || state.error != null) {
                        AppSnackbar.showError(context, "AI interviewer is currently unavailable.");
                      }
                    },
                    builder: (context, state) {
                      if (state.isLoading) {
                        return Center(child: CircularProgressIndicator(color: AppColors.primary));
                      }

                      final data = state.evaluation;
                      return ResponsiveContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            EvaluationHeader(),

                            //
                            const SizedBox(height: 16),
                            EvaluationScoreCard(
                              score: data?.overallScore ?? 0,
                              readinessLevel: data?.readinessLevel ?? "",
                            ),

                            const SizedBox(height: 16),

                            CompetenciesCard(
                              technicalKnowledge: data?.technicalKnowledge ?? 0,
                              problemSolving: data?.problemSolving ?? 0,
                              communication: data?.communication ?? 0,
                              confidence: data?.confidence ?? 0,
                            ),

                            const SizedBox(height: 16),
                            DetailedInsightsSection(
                              strengths: data?.strengths ?? [],
                              improvements: data?.improvements ?? [],
                            ),
                            const SizedBox(height: 16),

                            FocusAreasCard(missedTopics: data?.missedTopics ?? [], nextFocus: data?.nextFocus ?? []),
                            const SizedBox(height: 16),
                            ExecutiveSummaryCard(summary: data?.summary ?? ""),
                            const SizedBox(height: 36),

                            EvaluationActionButtons(
                              onRestart: () {
                                Navigator.popAndPushNamed(context, AppRoutes.interview);
                              },
                              onFinish: () {},
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EvaluationPageArgs {
  final String technology;
  final String experience;
  final List<QuestionAnswerEntity> questionAndAnswer;

  EvaluationPageArgs({required this.technology, required this.experience, required this.questionAndAnswer});
}
