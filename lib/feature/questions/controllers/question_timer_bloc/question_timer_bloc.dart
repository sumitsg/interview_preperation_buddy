import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_events.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_state.dart';

class QuestionTimerBloc extends Bloc<QuestionTimerEvent, QuestionTimerState> {
  QuestionTimerBloc() : super(const QuestionTimerState()) {
    on<StartQuestionFlow>(_onStartQuestionFlow);
    on<StartRecording>(_onStartRecording);
    on<CompleteAnswer>(_onCompleteAnswer);
    on<ResetTimerFlow>(_onReset);
    on<TimerTick>(_onTimerTick);
    on<StopRecordingTimer>(_onStopRecordingTimer);
  }

  static const int thinkingDuration = 15;

  Timer? _ticker;

  DateTime? _thinkingEndsAt;
  DateTime? _answerEndsAt;

  // ---------------------------------------------------------------------------
  // TIMER
  // ---------------------------------------------------------------------------

  void _startTicker() {
    _ticker?.cancel();

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) {
        add(const TimerTick());
      }
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  int _remainingSeconds(DateTime? endTime) {
    if (endTime == null) return 0;

    final remaining = endTime.difference(DateTime.now()).inSeconds;

    return remaining < 0 ? 0 : remaining;
  }

  // ---------------------------------------------------------------------------
  // START QUESTION
  // ---------------------------------------------------------------------------

  Future<void> _onStartQuestionFlow(
    StartQuestionFlow event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _thinkingEndsAt = DateTime.now().add(
      const Duration(seconds: thinkingDuration),
    );

    _answerEndsAt = null;

    emit(
      state.copyWith(
        phase: TimerPhase.thinking,
        remainingSeconds: thinkingDuration,
        answerRemainingSeconds: 0,
      ),
    );

    _startTicker();
  }

  // ---------------------------------------------------------------------------
  // START RECORDING
  // ---------------------------------------------------------------------------

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _answerEndsAt = DateTime.now().add(event.answerDuration);

    emit(
      state.copyWith(
        phase: TimerPhase.answering,
        remainingSeconds: 0,
        answerRemainingSeconds: event.answerDuration.inSeconds,
      ),
    );

    _startTicker();
  }

  // ---------------------------------------------------------------------------
  // TIMER TICK
  // ---------------------------------------------------------------------------

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

      case TimerPhase.completed:
      case TimerPhase.idle:
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // THINKING
  // ---------------------------------------------------------------------------

  void _handleThinking(Emitter<QuestionTimerState> emit) {
    final remaining = _remainingSeconds(_thinkingEndsAt);

    if (remaining <= 0) {
      _stopTicker();

      emit(state.copyWith(phase: TimerPhase.idle, remainingSeconds: 0));

      return;
    }

    emit(state.copyWith(remainingSeconds: remaining));
  }

  // ---------------------------------------------------------------------------
  // ANSWERING
  // ---------------------------------------------------------------------------

  void _handleAnswering(Emitter<QuestionTimerState> emit) {
    final remaining = _remainingSeconds(_answerEndsAt);

    if (remaining <= 0) {
      add(const CompleteAnswer());
      return;
    }

    emit(state.copyWith(answerRemainingSeconds: remaining));
  }

  // ---------------------------------------------------------------------------
  // COMPLETE
  // ---------------------------------------------------------------------------

  Future<void> _onCompleteAnswer(
    CompleteAnswer event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _stopTicker();

    emit(
      state.copyWith(phase: TimerPhase.completed, answerRemainingSeconds: 0),
    );
  }

  // ---------------------------------------------------------------------------
  // STOP RECORDING
  // ---------------------------------------------------------------------------

  Future<void> _onStopRecordingTimer(
    StopRecordingTimer event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _stopTicker();

    emit(state.copyWith(phase: TimerPhase.completed));
  }

  // ---------------------------------------------------------------------------
  // RESET
  // ---------------------------------------------------------------------------

  Future<void> _onReset(
    ResetTimerFlow event,
    Emitter<QuestionTimerState> emit,
  ) async {
    _stopTicker();

    _thinkingEndsAt = null;
    _answerEndsAt = null;

    emit(const QuestionTimerState());
  }

  // ---------------------------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() {
    _stopTicker();
    return super.close();
  }
}
