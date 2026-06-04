import 'dart:async';
import 'dart:ui';

import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';
import 'package:interview_preperation_buddy/core/models/answer_timer_state.dart';

class AnswerTimerManager {
  static const int preparationSeconds = 15;
  static const int waitingSeconds = 15;
  static const int warningSeconds = 15;
  static const int silenceTimeoutSeconds = 15;

  final _controller = StreamController<AnswerTimerState>.broadcast();

  Stream<AnswerTimerState> get stream => _controller.stream;

  Timer? _timer;

  DateTime? _answerStartedAt;
  DateTime? _lastSpeechAt;

  Duration _speakingDuration = Duration.zero;

  bool _hasSpoken = false;

  int _remainingSeconds = 0;

  AnswerPhase _phase = AnswerPhase.readingQuestion;

  AnswerTimerState get currentState => AnswerTimerState(
    phase: _phase,
    remainingSeconds: _remainingSeconds,
    speakingDuration: _speakingDuration,
    showSkipButton: _showSkipButton,
    hasSpoken: _hasSpoken,
  );

  bool get _showSkipButton =>
      _phase == AnswerPhase.waitingWarning ||
      _phase == AnswerPhase.speechWarning;

  void startQuestionFlow() {
    _cancelTimer();

    _hasSpoken = false;
    _speakingDuration = Duration.zero;
    _answerStartedAt = null;
    _lastSpeechAt = null;

    _startReadingPhase();
  }

  void startAnswer({required Duration answerDuration}) {
    _cancelTimer();

    _phase = AnswerPhase.answering;
    _remainingSeconds = answerDuration.inSeconds;

    _answerStartedAt = DateTime.now();
    _lastSpeechAt = DateTime.now();

    _emit();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;

      if (_answerStartedAt != null) {
        _speakingDuration = DateTime.now().difference(_answerStartedAt!);
      }

      if (!_hasSpoken &&
          _lastSpeechAt != null &&
          DateTime.now().difference(_lastSpeechAt!).inSeconds >=
              silenceTimeoutSeconds) {
        _startSpeechWarning();
        return;
      }

      if (_remainingSeconds <= 0) {
        complete();
        return;
      }

      _emit();
    });
  }

  void onSpeechDetected() {
    _hasSpoken = true;
    _lastSpeechAt = DateTime.now();

    if (_phase == AnswerPhase.speechWarning) {
      _phase = AnswerPhase.answering;
      _emit();
    }
  }

  void continueAfterSpeechWarning() {
    _lastSpeechAt = DateTime.now();
    _phase = AnswerPhase.answering;
    _emit();
  }

  void restartAnswer() {
    _hasSpoken = false;
    _speakingDuration = Duration.zero;
    _answerStartedAt = null;
    _lastSpeechAt = null;
  }

  void complete() {
    _cancelTimer();

    if (_answerStartedAt != null) {
      _speakingDuration = DateTime.now().difference(_answerStartedAt!);
    }

    _phase = AnswerPhase.completed;
    _emit();
  }

  void skip() {
    _cancelTimer();

    _phase = AnswerPhase.skipped;
    _emit();
  }

  void dispose() {
    _cancelTimer();
    _controller.close();
  }

  void _startReadingPhase() {
    _phase = AnswerPhase.readingQuestion;
    _remainingSeconds = preparationSeconds;

    _emit();

    _startCountdown(onCompleted: _startWaitingPhase);
  }

  void _startWaitingPhase() {
    _phase = AnswerPhase.waitingToStart;
    _remainingSeconds = waitingSeconds;

    _emit();

    _startCountdown(onCompleted: _startWaitingWarningPhase);
  }

  void _startWaitingWarningPhase() {
    _phase = AnswerPhase.waitingWarning;
    _remainingSeconds = warningSeconds;

    _emit();

    _startCountdown(onCompleted: skip);
  }

  void _startSpeechWarning() {
    _cancelTimer();

    _phase = AnswerPhase.speechWarning;
    _remainingSeconds = warningSeconds;

    _emit();

    _startCountdown(onCompleted: skip);
  }

  void _startCountdown({required VoidCallback onCompleted}) {
    _cancelTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;

      if (_remainingSeconds <= 0) {
        timer.cancel();
        onCompleted();
        return;
      }

      _emit();
    });
  }

  void _emit() {
    _controller.add(
      AnswerTimerState(
        phase: _phase,
        remainingSeconds: _remainingSeconds,
        speakingDuration: _speakingDuration,
        showSkipButton: _showSkipButton,
        hasSpoken: _hasSpoken,
      ),
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
