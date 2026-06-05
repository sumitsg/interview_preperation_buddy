import 'package:equatable/equatable.dart';

abstract class QuestionSttEvent extends Equatable {
  const QuestionSttEvent();

  @override
  List<Object?> get props => [];
}

class InitializeStt extends QuestionSttEvent {}

class StartListening extends QuestionSttEvent {
  final int listenDuration;

  const StartListening({required this.listenDuration});

  @override
  List<Object?> get props => [listenDuration];
}

class StopListening extends QuestionSttEvent {}

class CancelListening extends QuestionSttEvent {}

class TranscriptUpdated extends QuestionSttEvent {
  final String transcript;

  const TranscriptUpdated(this.transcript);

  @override
  List<Object?> get props => [transcript];
}

class ListeningCompleted extends QuestionSttEvent {}

class SttErrorOccurred extends QuestionSttEvent {
  final String error;

  const SttErrorOccurred(this.error);

  @override
  List<Object?> get props => [error];
}

class ResetStt extends QuestionSttEvent {
  const ResetStt();
}
