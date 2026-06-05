import 'package:equatable/equatable.dart';

abstract class EvaluateInterviewEvent extends Equatable {
  const EvaluateInterviewEvent();

  @override
  List<Object?> get props => [];
}

class EvaluateInterview extends EvaluateInterviewEvent {
  final String technology;
  final String experience;
  final String questionAndAnswer;

  const EvaluateInterview({required this.technology, required this.experience, required this.questionAndAnswer});

  @override
  List<Object?> get props => [technology, experience, questionAndAnswer];
}
