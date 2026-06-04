import 'dart:async';
import 'dart:ui';

import 'package:interview_preperation_buddy/core/constants/interview_constants.dart';
import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';
import 'package:interview_preperation_buddy/core/models/answer_timer_state.dart';

class AnswerTimerManager {
  static const int readingSeconds = InterviewConstants.preparationSeconds;

  static const int waitingSeconds = InterviewConstants.warningSeconds;

  static const int popupSeconds = InterviewConstants.autoSkipSeconds;

  static const int silenceSeconds = InterviewConstants.silenceTimeoutSeconds;

  final StreamController<AnswerTimerState> _controller =
      StreamController.broadcast();

  Stream<AnswerTimerState> get stream => _controller.stream;

  Timer? _mainTimer;
  Timer? _warningTimer;

  DateTime? _answerStartedAt;

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
      _phase == AnswerPhase.startRecordingWarning ||
      _phase == AnswerPhase.speechWarning;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  void startQuestionFlow() {
    _reset();

    _startReadingPhase();
  }

  void startAnswer({required Duration answerDuration}) {
    _cancelAllTimers();

    _phase = AnswerPhase.answering;

    _remainingSeconds = answerDuration.inSeconds;

    _answerStartedAt = DateTime.now();

    _hasSpoken = false;

    _speakingDuration = Duration.zero;

    _emit();

    _mainTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _handleAnswerTick(),
    );
  }

  /// Call from STT whenever user speaks.
  void onSpeechDetected() {
    _hasSpoken = true;

    if (_phase == AnswerPhase.speechWarning) {
      continueRecording();
    }
  }

  void continueRecording() {
    _cancelWarningTimer();

    _phase = AnswerPhase.answering;

    _emit();

    _mainTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _handleAnswerTick(),
    );
  }

  void complete() {
    _cancelAllTimers();

    if (_answerStartedAt != null) {
      _speakingDuration = DateTime.now().difference(_answerStartedAt!);
    }

    _phase = AnswerPhase.completed;

    _emit();
  }

  void skip() {
    _cancelAllTimers();

    _phase = AnswerPhase.skipped;

    _emit();
  }

  void dispose() {
    _cancelAllTimers();
    _controller.close();
  }

  // ---------------------------------------------------------------------------
  // QUESTION FLOW
  // ---------------------------------------------------------------------------

  void _startReadingPhase() {
    _phase = AnswerPhase.readingQuestion;

    _remainingSeconds = readingSeconds;

    _emit();

    _startCountdown(seconds: readingSeconds, onCompleted: _startWaitingPhase);
  }

  void _startWaitingPhase() {
    _phase = AnswerPhase.waitingToStart;

    _remainingSeconds = waitingSeconds;

    _emit();

    _startCountdown(
      seconds: waitingSeconds,
      onCompleted: _showStartRecordingPopup,
    );
  }

  void _showStartRecordingPopup() {
    _phase = AnswerPhase.startRecordingWarning;

    _remainingSeconds = popupSeconds;

    _emit();

    _startCountdown(seconds: popupSeconds, onCompleted: skip);
  }

  // ---------------------------------------------------------------------------
  // ANSWER FLOW
  // ---------------------------------------------------------------------------

  void _handleAnswerTick() {
    _remainingSeconds--;

    if (_answerStartedAt != null) {
      _speakingDuration = DateTime.now().difference(_answerStartedAt!);

      final secondsSinceStart = DateTime.now()
          .difference(_answerStartedAt!)
          .inSeconds;

      if (!_hasSpoken && secondsSinceStart >= silenceSeconds) {
        _showSpeechWarning();
        return;
      }
    }

    if (_remainingSeconds <= 0) {
      complete();
      return;
    }

    _emit();
  }

  void _showSpeechWarning() {
    _cancelMainTimer();

    _phase = AnswerPhase.speechWarning;

    _remainingSeconds = popupSeconds;

    _emit();

    _warningTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;

      if (_remainingSeconds <= 0) {
        timer.cancel();
        skip();
        return;
      }

      _emit();
    });
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  void _startCountdown({
    required int seconds,
    required VoidCallback onCompleted,
  }) {
    _cancelMainTimer();

    _remainingSeconds = seconds;

    _mainTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;

      if (_remainingSeconds <= 0) {
        timer.cancel();
        onCompleted();
        return;
      }

      _emit();
    });
  }

  void _reset() {
    _cancelAllTimers();

    _answerStartedAt = null;

    _speakingDuration = Duration.zero;

    _remainingSeconds = 0;

    _hasSpoken = false;
  }

  void _emit() {
    if (_controller.isClosed) return;

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

  void _cancelMainTimer() {
    _mainTimer?.cancel();
    _mainTimer = null;
  }

  void _cancelWarningTimer() {
    _warningTimer?.cancel();
    _warningTimer = null;
  }

  void _cancelAllTimers() {
    _cancelMainTimer();
    _cancelWarningTimer();
  }
}
