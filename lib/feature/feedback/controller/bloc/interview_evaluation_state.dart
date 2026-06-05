import 'package:equatable/equatable.dart';
import 'package:interview_preperation_buddy/core/models/interview_evaluation.dart';

class EvaluateInterviewState extends Equatable {
  final bool isLoading;
  final InterviewEvaluation? evaluation;
  final String? error;
  const EvaluateInterviewState({this.isLoading = false, this.evaluation, this.error});

  EvaluateInterviewState copyWith({
    bool? isLoading,

    int? currentQuestionIndex,
    bool? isInterviewCompleted,
    InterviewEvaluation? evaluation,
    String? error,
  }) {
    return EvaluateInterviewState(
      isLoading: isLoading ?? this.isLoading,
      evaluation: evaluation ?? this.evaluation,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, evaluation, error];
}
