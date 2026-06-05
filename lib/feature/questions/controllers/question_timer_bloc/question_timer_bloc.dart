import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_events.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_state.dart';

class QuestionTimerBloc extends Bloc<QuestionTimerEvent, QuestionTimerState> {
  QuestionTimerBloc() : super(const QuestionTimerState()) {
    on<StartQuestionFlow>(_onStartQuestionFlow);

    on<StartRecording>(_onStartRecording);

    on<SpeechDetected>(_onSpeechDetected);

    on<ContinueRecording>(_onContinueRecording);

    on<SkipQuestion>(_onSkipQuestion);

    on<CompleteAnswer>(_onCompleteAnswer);

    on<ResetTimerFlow>(_onReset);

    on<TimerTick>(_onTimerTick);
  }

  Timer? _timer;

  int _remainingSeconds = 0;

  int _answerRemainingSeconds = 0;

  int _silenceCounter = 0;

  Future<void> _onStartQuestionFlow(
    StartQuestionFlow event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _startPhase(emit, phase: TimerPhase.thinking, seconds: 15);
  }

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _timer?.cancel();

    _answerRemainingSeconds = event.answerDuration.inSeconds;
    _silenceCounter = 0;

    emit(
      state.copyWith(
        phase: TimerPhase.answering,
        answerRemainingSeconds: _answerRemainingSeconds,
        hasSpoken: false,
      ),
    );

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(TimerTick()),
    );
  }

  Future<void> _onSpeechDetected(
    SpeechDetected event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _silenceCounter = 0;

    emit(state.copyWith(hasSpoken: true));
  }

  Future<void> _onContinueRecording(
    ContinueRecording event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _timer?.cancel();

    _silenceCounter = 0;

    emit(
      state.copyWith(
        phase: TimerPhase.answering,
        hasSpoken: true,
        answerRemainingSeconds: _answerRemainingSeconds,
      ),
    );

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(TimerTick()),
    );
  }

  Future<void> _onTimerTick(
    TimerTick event,
    Emitter<QuestionTimerState> emit,
  ) async {
    switch (state.phase) {
      case TimerPhase.thinking:
        _handleThinking(emit);
        break;

      case TimerPhase.answering:
        _handleAnswering(emit);
        break;

      case TimerPhase.speechWarning:
        _handleSpeechWarning(emit);
        break;

      default:
        break;
    }
  }

  void _handleThinking(Emitter<QuestionTimerState> emit) {
    _remainingSeconds--;

    emit(state.copyWith(remainingSeconds: _remainingSeconds));

    if (_remainingSeconds <= 0) {
      _timer?.cancel();

      emit(state.copyWith(phase: TimerPhase.idle, remainingSeconds: 0));
    }
  }

  void _handleAnswering(Emitter<QuestionTimerState> emit) {
    _answerRemainingSeconds--;

    if (!state.hasSpoken) {
      _silenceCounter++;
    }

    emit(state.copyWith(answerRemainingSeconds: _answerRemainingSeconds));

    if (!state.hasSpoken && _silenceCounter >= 15) {
      _startPhase(emit, phase: TimerPhase.speechWarning, seconds: 15);
      return;
    }

    if (_answerRemainingSeconds <= 0) {
      add(CompleteAnswer());
    }
  }

  void _handleSpeechWarning(Emitter<QuestionTimerState> emit) {
    _remainingSeconds--;

    emit(state.copyWith(remainingSeconds: _remainingSeconds));

    if (_remainingSeconds <= 0) {
      add(SkipQuestion());
    }
  }

  void _startPhase(
    Emitter<QuestionTimerState> emit, {
    required TimerPhase phase,
    required int seconds,
  }) {
    _remainingSeconds = seconds;

    emit(state.copyWith(phase: phase, remainingSeconds: seconds));

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(TimerTick()),
    );
  }

  Future<void> _onSkipQuestion(
    SkipQuestion event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _timer?.cancel();

    emit(state.copyWith(phase: TimerPhase.skipped));
  }

  Future<void> _onCompleteAnswer(
    CompleteAnswer event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _timer?.cancel();

    emit(state.copyWith(phase: TimerPhase.completed));
  }

  Future<void> _onReset(
    ResetTimerFlow event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _timer?.cancel();

    _remainingSeconds = 0;
    _answerRemainingSeconds = 0;
    _silenceCounter = 0;

    emit(const QuestionTimerState());
  }
}
