import 'package:equatable/equatable.dart';
import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';

class QuestionTimerState extends Equatable {
  final TimerPhase phase;

  /// Thinking timer
  final int remainingSeconds;

  /// Answer timer
  final int answerRemainingSeconds;

  /// Seconds user has never spoken
  final int noSpeechSeconds;

  /// User has spoken at least once
  final bool hasSpoken;

  const QuestionTimerState({
    this.phase = TimerPhase.idle,
    this.remainingSeconds = 0,
    this.answerRemainingSeconds = 0,
    this.noSpeechSeconds = 0,
    this.hasSpoken = false,
  });

  QuestionTimerState copyWith({
    TimerPhase? phase,
    int? remainingSeconds,
    int? answerRemainingSeconds,
    int? noSpeechSeconds,
    bool? hasSpoken,
  }) {
    return QuestionTimerState(
      phase: phase ?? this.phase,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      answerRemainingSeconds:
          answerRemainingSeconds ?? this.answerRemainingSeconds,
      noSpeechSeconds: noSpeechSeconds ?? this.noSpeechSeconds,
      hasSpoken: hasSpoken ?? this.hasSpoken,
    );
  }

  @override
  List<Object> get props => [
    phase,
    remainingSeconds,
    answerRemainingSeconds,
    noSpeechSeconds,
    hasSpoken,
  ];

  @override
  String toString() {
    return '''
QuestionTimerState(
  phase: $phase,
  remainingSeconds: $remainingSeconds,
  answerRemainingSeconds: $answerRemainingSeconds,
  noSpeechSeconds: $noSpeechSeconds,
  hasSpoken: $hasSpoken
)
''';
  }
}
