import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/app/di/injection_container.dart';
import 'package:interview_preperation_buddy/core/services/stt_service.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/quesion_stt_state.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_event.dart';

class QuestionSttBloc extends Bloc<QuestionSttEvent, QuestionSttState> {
  final SttService _sttService = sl<SttService>();

  QuestionSttBloc() : super(const QuestionSttState()) {
    on<InitializeStt>(_onInitialize);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<CancelListening>(_onCancelListening);
    on<TranscriptUpdated>(_onTranscriptUpdated);
    on<ListeningCompleted>(_onListeningCompleted);
    on<SttErrorOccurred>(_onErrorOccurred);
  }

  Future<void> _onInitialize(
    InitializeStt event,
    Emitter<QuestionSttState> emit,
  ) async {
    emit(state.copyWith(status: SttBlocStatus.initializing));

    final success = await _sttService.initialize();

    emit(
      state.copyWith(
        status: success ? SttBlocStatus.ready : SttBlocStatus.error,
        error: success ? null : 'Speech unavailable',
      ),
    );
  }

  Future<void> _onStartListening(
    StartListening event,
    Emitter<QuestionSttState> emit,
  ) async {
    emit(
      state.copyWith(
        transcript: '',
        error: null,
        status: SttBlocStatus.listening,
      ),
    );

    await _sttService.startListening(
      listenDuration: event.listenDuration,

      onResult: (text) {
        add(TranscriptUpdated(text));
      },

      onError: (error) {
        add(SttErrorOccurred(error));
      },

      onListeningComplete: () {
        add(ListeningCompleted());
      },
    );
  }

  Future<void> _onStopListening(
    StopListening event,
    Emitter<QuestionSttState> emit,
  ) async {
    await _sttService.stopListening();

    emit(state.copyWith(status: SttBlocStatus.completed));
  }

  Future<void> _onCancelListening(
    CancelListening event,
    Emitter<QuestionSttState> emit,
  ) async {
    await _sttService.cancelListening();

    emit(state.copyWith(status: SttBlocStatus.ready, transcript: ''));
  }

  void _onTranscriptUpdated(
    TranscriptUpdated event,
    Emitter<QuestionSttState> emit,
  ) {
    emit(state.copyWith(transcript: event.transcript));
  }

  void _onListeningCompleted(
    ListeningCompleted event,
    Emitter<QuestionSttState> emit,
  ) {
    emit(state.copyWith(status: SttBlocStatus.completed));
  }

  void _onErrorOccurred(
    SttErrorOccurred event,
    Emitter<QuestionSttState> emit,
  ) {
    emit(state.copyWith(status: SttBlocStatus.error, error: event.error));
  }

  @override
  Future<void> close() async {
    await _sttService.cancelListening();
    return super.close();
  }
}
