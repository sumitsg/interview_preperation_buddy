import 'package:equatable/equatable.dart';
import '../../../core/models/candidate_answer.dart';
import '../../../core/models/interview_evaluation.dart';
import '../../../core/models/interview_question_model.dart';

class InterviewState extends Equatable {
  final bool isLoading;

  final List<InterviewQuestion> questions;

  final List<CandidateAnswer> answers;

  final int currentQuestionIndex;

  final bool isInterviewCompleted;

  final InterviewEvaluation? evaluation;

  final String? error;

  const InterviewState({
    this.isLoading = false,
    this.questions = const [],
    this.answers = const [],
    this.currentQuestionIndex = 0,
    this.isInterviewCompleted = false,
    this.evaluation,
    this.error,
  });

  InterviewState copyWith({
    bool? isLoading,
    List<InterviewQuestion>? questions,
    List<CandidateAnswer>? answers,
    int? currentQuestionIndex,
    bool? isInterviewCompleted,
    InterviewEvaluation? evaluation,
    String? error,
  }) {
    return InterviewState(
      isLoading: isLoading ?? this.isLoading,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      currentQuestionIndex:
      currentQuestionIndex ??
          this.currentQuestionIndex,
      isInterviewCompleted:
      isInterviewCompleted ??
          this.isInterviewCompleted,
      evaluation:
      evaluation ?? this.evaluation,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    questions,
    answers,
    currentQuestionIndex,
    isInterviewCompleted,
    evaluation,
    error,
  ];
}