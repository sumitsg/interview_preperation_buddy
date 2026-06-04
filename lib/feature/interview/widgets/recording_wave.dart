import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_colors.dart';
import 'package:lottie/lottie.dart';

class RecordingWave extends StatelessWidget {
  const RecordingWave({super.key, this.width = 120, this.height = 60});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      "assets/animations/recording_wave.json",
      width: width,
      height: height,
      repeat: true,
      animate: true,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(const ['**'], value: AppColors.primary),
        ],
      ),
      fit: BoxFit.contain,
    );
  }
}
