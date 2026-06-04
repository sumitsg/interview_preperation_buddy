import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_button.dart';

class FooterActions extends StatelessWidget {
  const FooterActions({super.key, this.onRestart, this.onSkip, this.onStart, this.onStop});

  final VoidCallback? onRestart;
  final VoidCallback? onSkip;
  final VoidCallback? onStart;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (onRestart != null) AppButton(title: 'Restart', onPressed: onRestart),
        if (onSkip != null) AppButton(title: 'Skip', onPressed: onSkip),
        if (onStart != null) AppButton(title: 'Start', onPressed: onStart),
        if (onStop != null) AppButton(title: 'Stop', onPressed: onStop),
      ],
    );
  }
}
