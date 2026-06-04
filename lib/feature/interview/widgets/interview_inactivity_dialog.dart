import 'package:flutter/material.dart';

class InterviewInactivityDialog extends StatelessWidget {
  const InterviewInactivityDialog({
    super.key,
    required this.remainingSeconds,
    required this.onContinue,
    required this.onSkip,
  });

  final int remainingSeconds;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.mic_off, color: Colors.red, size: 32),
            ),

            const SizedBox(height: 24),

            const Text('No speech detected', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),

            const SizedBox(height: 12),

            const Text(
              'We haven\'t heard anything for 15 seconds.\nDo you want to continue or skip this question?',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Text(
                'Auto-skipping in ${remainingSeconds}s',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onContinue,
                icon: const Icon(Icons.mic),
                label: const Text('Continue Answering'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onSkip,
                icon: const Icon(Icons.skip_next),
                label: const Text('Skip Question'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
