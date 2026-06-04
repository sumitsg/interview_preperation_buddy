import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_colors.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_card.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_text.dart';

class DetailedInsightsSection extends StatelessWidget {
  const DetailedInsightsSection({super.key, required this.strengths, required this.improvements});

  final List<String> strengths;
  final List<String> improvements;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('DETAILED INSIGHTS', style: AppTextStyles.labelLarge),

          const SizedBox(height: 24),

          InsightsGroup(
            title: 'Key Strengths',
            items: strengths,
            icon: Icons.check_circle_outline,
            itemBackgroundColor: AppColors.strengthBackground,
          ),

          const SizedBox(height: 24),

          InsightsGroup(
            title: 'Areas for Improvement',
            items: improvements,
            icon: Icons.info_outline,
            itemBackgroundColor: AppColors.improvementBackground,
          ),
        ],
      ),
    );
  }
}

class InsightsGroup extends StatelessWidget {
  const InsightsGroup({
    super.key,
    required this.title,
    required this.items,
    required this.icon,
    required this.itemBackgroundColor,
  });

  final String title;
  final List<String> items;
  final IconData icon;
  final Color itemBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),

            const SizedBox(width: 8),

            AppText(title, style: AppTextStyles.bodyMedium),
          ],
        ),

        const SizedBox(height: 12),

        ...items.map((item) => InsightItem(text: item, backgroundColor: itemBackgroundColor)),
      ],
    );
  }
}

class InsightItem extends StatelessWidget {
  const InsightItem({super.key, required this.text, required this.backgroundColor});

  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
      child: AppText(text),
    );
  }
}
