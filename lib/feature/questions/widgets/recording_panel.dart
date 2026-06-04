import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_badge.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_card.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_stat_tile.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_timer.dart';

import 'voice_wave.dart';

class RecordingPanel extends StatelessWidget {
  const RecordingPanel({super.key, required this.duration, required this.wordCount, required this.onTimerCompleted});

  final int duration;
  final int wordCount;
  final VoidCallback onTimerCompleted;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const AppBadge(title: 'Recording', color: Colors.red),
          const SizedBox(height: 20),
          const VoiceWave(),
          const SizedBox(height: 20),
          AppTimer(seconds: duration, onCompleted: onTimerCompleted),
          const SizedBox(height: 20),
          AppStatTile(title: 'Words', value: wordCount.toString()),
        ],
      ),
    );
  }
}
