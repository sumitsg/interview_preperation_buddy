import 'package:interview_preperation_buddy/core/enums/tts_state.dart';

class TtsState {
  final TtsStatus status;
  final String? error;

  const TtsState({this.status = TtsStatus.initial, this.error});

  TtsState copyWith({TtsStatus? status, String? error}) {
    return TtsState(status: status ?? this.status, error: error);
  }
}
