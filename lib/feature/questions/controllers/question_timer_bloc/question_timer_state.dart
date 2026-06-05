import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';

class QuestionTimerState {
  final TimerPhase phase;

  final int remainingSeconds;

  final int answerRemainingSeconds;

  final bool hasSpoken;

  const QuestionTimerState({
    this.phase = TimerPhase.idle,
    this.remainingSeconds = 0,
    this.answerRemainingSeconds = 0,
    this.hasSpoken = false,
  });

  QuestionTimerState copyWith({
    TimerPhase? phase,
    int? remainingSeconds,
    int? answerRemainingSeconds,
    bool? hasSpoken,
  }) {
    return QuestionTimerState(
      phase: phase ?? this.phase,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      answerRemainingSeconds:
          answerRemainingSeconds ?? this.answerRemainingSeconds,
      hasSpoken: hasSpoken ?? this.hasSpoken,
    );
  }
}
