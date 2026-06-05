abstract class QuestionTimerEvent {
  const QuestionTimerEvent();
}

class StartQuestionFlow extends QuestionTimerEvent {
  const StartQuestionFlow();
}

class StartRecording extends QuestionTimerEvent {
  final Duration answerDuration;

  const StartRecording(this.answerDuration);
}

class SpeechDetected extends QuestionTimerEvent {
  const SpeechDetected();
}

class ContinueRecording extends QuestionTimerEvent {
  const ContinueRecording();
}

class CompleteAnswer extends QuestionTimerEvent {
  const CompleteAnswer();
}

class SkipQuestion extends QuestionTimerEvent {
  const SkipQuestion();
}

class ResetTimerFlow extends QuestionTimerEvent {
  const ResetTimerFlow();
}

class TimerTick extends QuestionTimerEvent {
  const TimerTick();
}
