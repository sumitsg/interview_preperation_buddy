import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/app/di/injection_container.dart';
import 'package:interview_preperation_buddy/core/enums/tts_state.dart';
import 'package:interview_preperation_buddy/core/services/tts_service.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/tts_bloc/tts_state.dart';

class TtsCubit extends Cubit<TtsState> {
  final TtsService _ttsService = sl<TtsService>();

  TtsCubit() : super(const TtsState());

  Future<void> initialize() async {
    emit(state.copyWith(status: TtsStatus.initializing));

    try {
      final success = await _ttsService.initialize();

      if (!success) {
        emit(
          state.copyWith(
            status: TtsStatus.error,
            error: 'Failed to initialize TTS',
          ),
        );
        return;
      }

      emit(state.copyWith(status: TtsStatus.ready));
    } catch (e) {
      emit(state.copyWith(status: TtsStatus.error, error: e.toString()));
    }
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    try {
      await _ttsService.stop();

      emit(state.copyWith(status: TtsStatus.speaking));
      await Future.delayed(const Duration(milliseconds: 100));

      await _ttsService.speak(
        text: text,
        onCompleted: () {
          emit(state.copyWith(status: TtsStatus.completed));
        },
        onError: (error) {
          emit(state.copyWith(status: TtsStatus.error, error: error));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: TtsStatus.error, error: e.toString()));
    }
  }

  Future<void> stop() async {
    await _ttsService.stop();

    emit(state.copyWith(status: TtsStatus.stopped));
  }

  @override
  Future<void> close() async {
    await _ttsService.stop();
    return super.close();
  }

  void reset() {}
}
