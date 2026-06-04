import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_card.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_progess_bar.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_text.dart';

class CompetenciesCard extends StatelessWidget {
  const CompetenciesCard({
    super.key,
    required this.technicalKnowledge,
    required this.problemSolving,
    required this.communication,
    required this.confidence,
  });

  final int technicalKnowledge;
  final int problemSolving;
  final int communication;
  final int confidence;

  @override
  Widget build(BuildContext context) {
    final competencies = [
      _CompetencyItemModel(title: 'Technical Knowledge', score: technicalKnowledge),
      _CompetencyItemModel(title: 'Problem Solving', score: problemSolving),
      _CompetencyItemModel(title: 'Communication', score: communication),
      _CompetencyItemModel(title: 'Confidence', score: confidence),
    ];

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('CORE COMPETENCIES', style: AppTextStyles.labelLarge),

          const SizedBox(height: 20),

          Column(
            children: List.generate(
              competencies.length,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: index == competencies.length - 1 ? 0 : 20),
                child: CompetencyProgressItem(
                  title: competencies[index].title,
                  score: (competencies[index].score).toDouble(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompetencyItemModel {
  final String title;
  final int score;

  const _CompetencyItemModel({required this.title, required this.score});
}

class CompetencyProgressItem extends StatelessWidget {
  const CompetencyProgressItem({super.key, required this.title, required this.score});

  final String title;
  final double score;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: AppText(title, style: AppTextStyles.bodyMedium)),

            AppText('$score%', style: AppTextStyles.bodySmall),
          ],
        ),

        const SizedBox(height: 8),

        AppProgressBar(value: score / 100),
      ],
    );
  }
}
