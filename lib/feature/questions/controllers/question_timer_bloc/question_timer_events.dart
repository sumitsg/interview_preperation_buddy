abstract class QuestionTimerEvent {}

class StartQuestionFlow extends QuestionTimerEvent {}

class StartRecording extends QuestionTimerEvent {
  final Duration answerDuration;

  StartRecording(this.answerDuration);
}

class SpeechDetected extends QuestionTimerEvent {}

class ContinueRecording extends QuestionTimerEvent {}

class SkipQuestion extends QuestionTimerEvent {}

class CompleteAnswer extends QuestionTimerEvent {}

class ResetTimerFlow extends QuestionTimerEvent {}

class TimerTick extends QuestionTimerEvent {}
