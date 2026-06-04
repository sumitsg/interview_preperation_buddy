import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_button.dart';

class EvaluationActionButtons extends StatelessWidget {
  const EvaluationActionButtons({super.key, required this.onRestart, required this.onFinish});

  final VoidCallback onRestart;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton(title: 'Restart Interview', onPressed: onRestart, icon: Icon(Icons.refresh_outlined)),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(onPressed: onFinish, child: const Text('Finish Process')),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
