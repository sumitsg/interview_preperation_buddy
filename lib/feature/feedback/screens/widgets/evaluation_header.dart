import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_text.dart';

class EvaluationHeader extends StatelessWidget {
  const EvaluationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Performance Analysis', style: AppTextStyles.headline2),

        const SizedBox(height: 4),

        AppText('Review your detailed interview metrics.', style: AppTextStyles.bodySmall),
      ],
    );
  }
}
