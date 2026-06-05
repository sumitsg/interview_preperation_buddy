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

  static const int thinkingDuration = 15;
  static const int warningDuration = 15;
  static const int noSpeechThreshold = 15;

  void _startTicker() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const TimerTick()),
    );
  }

  Future<void> _onStartQuestionFlow(
    StartQuestionFlow event,
    Emitter<QuestionTimerState> emit,
  ) async {
    emit(
      state.copyWith(
        phase: TimerPhase.thinking,
        remainingSeconds: thinkingDuration,
        answerRemainingSeconds: 0,
        noSpeechSeconds: 0,
        hasSpoken: false,
      ),
    );

    _startTicker();
  }

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<QuestionTimerState> emit,
  ) async {
    emit(
      state.copyWith(
        phase: TimerPhase.answering,
        answerRemainingSeconds: event.answerDuration.inSeconds,
        noSpeechSeconds: 0,
        hasSpoken: false,
      ),
    );

    _startTicker();
  }

  Future<void> _onSpeechDetected(
    SpeechDetected event,
    Emitter<QuestionTimerState> emit,
  ) async {
    if (state.hasSpoken) return;

    emit(state.copyWith(hasSpoken: true));
  }

  Future<void> _onContinueRecording(
    ContinueRecording event,
    Emitter<QuestionTimerState> emit,
  ) async {
    emit(state.copyWith(phase: TimerPhase.answering));

    _startTicker();
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
    final remaining = state.remainingSeconds - 1;

    emit(state.copyWith(remainingSeconds: remaining));

    if (remaining <= 0) {
      _timer?.cancel();

      emit(state.copyWith(phase: TimerPhase.idle, remainingSeconds: 0));
    }
  }

  void _handleAnswering(Emitter<QuestionTimerState> emit) {
    final answerRemaining = state.answerRemainingSeconds - 1;

    final noSpeechSeconds = state.hasSpoken
        ? state.noSpeechSeconds
        : state.noSpeechSeconds + 1;

    emit(
      state.copyWith(
        answerRemainingSeconds: answerRemaining,
        noSpeechSeconds: noSpeechSeconds,
      ),
    );

    if (!state.hasSpoken && noSpeechSeconds >= noSpeechThreshold) {
      emit(
        state.copyWith(
          phase: TimerPhase.speechWarning,
          remainingSeconds: warningDuration,
        ),
      );

      return;
    }

    if (answerRemaining <= 0) {
      add(const CompleteAnswer());
    }
  }

  void _handleSpeechWarning(Emitter<QuestionTimerState> emit) {
    final remaining = state.remainingSeconds - 1;

    emit(state.copyWith(remainingSeconds: remaining));

    if (remaining <= 0) {
      add(const SkipQuestion());
    }
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

    emit(const QuestionTimerState());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
