import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/widgets/score_card_indicator.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_badge.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_card.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_text.dart';

class EvaluationScoreCard extends StatelessWidget {
  final int score;
  final String readinessLevel;

  const EvaluationScoreCard({super.key, required this.score, required this.readinessLevel});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('OVERALL SCORE', style: AppTextStyles.labelLarge),

          const SizedBox(height: 16),

          Row(
            children: [
              ScoreIndicator(score: score),

              const SizedBox(width: 12),

              AppBadge(title: readinessLevel),
            ],
          ),
        ],
      ),
    );
  }
}
