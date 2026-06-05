import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_card.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_text.dart';

class ExecutiveSummaryCard extends StatelessWidget {
  const ExecutiveSummaryCard({super.key, required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('EXECUTIVE SUMMARY', style: AppTextStyles.labelLarge),

          const SizedBox(height: 16),

          AppText(summary, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
