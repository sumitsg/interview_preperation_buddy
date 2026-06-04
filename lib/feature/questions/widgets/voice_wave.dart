import 'dart:math';

import 'package:flutter/material.dart';

class VoiceWave extends StatefulWidget {
  const VoiceWave({super.key, this.barCount = 20});

  final int barCount;

  @override
  State<VoiceWave> createState() => _VoiceWaveState();
}

class _VoiceWaveState extends State<VoiceWave> {
  final random = Random();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.barCount, (index) {
          final height = random.nextDouble() * 50 + 10;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 4,
            height: height,
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
          );
        }),
      ),
    );
  }
}
