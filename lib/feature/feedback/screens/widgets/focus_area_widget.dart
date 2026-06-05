import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_colors.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_badge.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_card.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_text.dart';

class FocusAreasCard extends StatelessWidget {
  const FocusAreasCard({super.key, required this.missedTopics, required this.nextFocus});

  final List<String> missedTopics;
  final List<String> nextFocus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: AppCard(
        // padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('FOCUS AREAS', style: AppTextStyles.labelLarge),

            const SizedBox(height: 20),

            AppText('MISSED TOPICS', style: AppTextStyles.labelSmall),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: missedTopics.map((topic) => AppBadge(title: topic, color: AppColors.neutralMid)).toList(),
            ),

            const SizedBox(height: 24),

            AppText('NEXT FOCUS', style: AppTextStyles.labelSmall),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: nextFocus
                  .map(
                    (topic) => AppBadge(
                      title: topic,
                      color: AppColors.primary,
                      // optional highlighted chip
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
