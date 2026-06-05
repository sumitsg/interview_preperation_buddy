import 'package:equatable/equatable.dart';

abstract class InterviewEvent extends Equatable {
  const InterviewEvent();

  @override
  List<Object?> get props => [];
}

class GenerateQuestionsEvent extends InterviewEvent {

  final String technology;
  final String experience;

  const GenerateQuestionsEvent({
    required this.technology,
    required this.experience,
  });

  @override
  List<Object?> get props => [
    technology,
    experience,
  ];
}

class SubmitAnswerEvent
    extends InterviewEvent {

  final String answer;

  const SubmitAnswerEvent(
      this.answer,
      );

  @override
  List<Object?> get props => [answer];
}
