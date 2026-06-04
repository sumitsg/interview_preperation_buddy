import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_text.dart';

class ScoreIndicator extends StatelessWidget {
  const ScoreIndicator({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      width: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 4,
            constraints: BoxConstraints(minWidth: 50, minHeight: 50),
          ),
          AppText('$score', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
