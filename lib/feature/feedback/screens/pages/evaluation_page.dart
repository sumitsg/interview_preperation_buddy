import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/core/responsive/responsive.dart';
import 'package:interview_preperation_buddy/feature/feedback/dummy/evaluation_dummy_data.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/competencies_card.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/detailed_insight_section.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/evaluation_action_button.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/evaluation_header.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/evaluation_score_card.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/executive_summary_card.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/focus_area_widget.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/interview_setup_header.dart';
import 'package:interview_preperation_buddy/shared/widgets/responsive_container.dart';

class EvaluationPage extends StatelessWidget {
  const EvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = evaluationDummy;

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
                  child: ResponsiveContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        EvaluationHeader(),

                        //
                        const SizedBox(height: 16),
                        EvaluationScoreCard(score: data.overallScore, readinessLevel: data.readinessLevel),

                        const SizedBox(height: 16),

                        CompetenciesCard(
                          technicalKnowledge: data.technicalKnowledge,
                          problemSolving: data.problemSolving,
                          communication: data.communication,
                          confidence: data.confidence,
                        ),

                        const SizedBox(height: 16),
                        ExecutiveSummaryCard(summary: data.summary),

                        const SizedBox(height: 16),
                        DetailedInsightsSection(strengths: data.strengths, improvements: data.improvements),
                        const SizedBox(height: 16),

                        FocusAreasCard(missedTopics: data.missedTopics, nextFocus: data.nextFocus),
                        const SizedBox(height: 36),

                        EvaluationActionButtons(onRestart: () {}, onFinish: () {}),
                      ],
                    ),
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
