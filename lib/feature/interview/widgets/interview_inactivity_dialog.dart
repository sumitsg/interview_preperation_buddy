import 'package:flutter/material.dart';

class InterviewInactivityDialog extends StatefulWidget {
  const InterviewInactivityDialog({
    super.key,
    required this.remainingSeconds,
    required this.onContinue,
    required this.onSkip,
    required this.onTimerFinished,
  });

  final int remainingSeconds;

  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final VoidCallback onTimerFinished;

  @override
  State<InterviewInactivityDialog> createState() => _InterviewInactivityDialogState();
}

class _InterviewInactivityDialogState extends State<InterviewInactivityDialog> {
  bool _timerFinishedCalled = false;
  bool _actionTaken = false;

  @override
  void didUpdateWidget(covariant InterviewInactivityDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.remainingSeconds <= 0 && !_timerFinishedCalled && !_actionTaken) {
      _timerFinishedCalled = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        widget.onTimerFinished();
      });
    }
  }

  void _handleContinue() {
    if (_actionTaken) return;

    _actionTaken = true;
    widget.onContinue();
  }

  void _handleSkip() {
    if (_actionTaken) return;

    _actionTaken = true;
    widget.onSkip();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
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

            const Text(
              'No speech detected',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),

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
                'Auto-skipping in ${widget.remainingSeconds}s',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleContinue,
                icon: const Icon(Icons.mic),
                label: const Text('Continue Answering'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _handleSkip,
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
