import 'package:equatable/equatable.dart';

enum SttBlocStatus { initial, initializing, ready, listening, completed, error }

class QuestionSttState extends Equatable {
  final SttBlocStatus status;
  final String transcript;
  final String? error;

  const QuestionSttState({
    this.status = SttBlocStatus.initial,
    this.transcript = '',
    this.error,
  });

  bool get isListening => status == SttBlocStatus.listening;

  QuestionSttState copyWith({
    SttBlocStatus? status,
    String? transcript,
    String? error,
  }) {
    return QuestionSttState(
      status: status ?? this.status,
      transcript: transcript ?? this.transcript,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, transcript, error];
}
