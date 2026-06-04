import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';

class AnswerTimerState {
  final AnswerPhase phase;
  final int remainingSeconds;
  final Duration speakingDuration;
  final bool showSkipButton;
  final bool hasSpoken;

  const AnswerTimerState({
    required this.phase,
    required this.remainingSeconds,
    required this.speakingDuration,
    required this.showSkipButton,
    required this.hasSpoken,
  });

  AnswerTimerState copyWith({
    AnswerPhase? phase,
    int? remainingSeconds,
    Duration? speakingDuration,
    bool? showSkipButton,
    bool? hasSpoken,
  }) {
    return AnswerTimerState(
      phase: phase ?? this.phase,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      speakingDuration: speakingDuration ?? this.speakingDuration,
      showSkipButton: showSkipButton ?? this.showSkipButton,
      hasSpoken: hasSpoken ?? this.hasSpoken,
    );
  }
}
