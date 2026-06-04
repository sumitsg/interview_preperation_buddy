// import 'package:equatable/equatable.dart';
//
// import '../../../core/models/candidate_answer.dart';
// import '../../../core/models/interview_question_model.dart';
//
//
// class InterviewState extends Equatable {
//   final bool isLoading;
//
//   final List<InterviewQuestion> questions;
//
//   final List<CandidateAnswer> answers;
//
//   final int currentIndex;
//
//   final bool interviewCompleted;
//
//   const InterviewState({
//     this.isLoading = false,
//     this.questions = const [],
//     this.answers = const [],
//     this.currentIndex = 0,
//     this.interviewCompleted = false,
//   });
//
//   InterviewState copyWith({
//     bool? isLoading,
//     List<InterviewQuestion>? questions,
//     List<CandidateAnswer>? answers,
//     int? currentIndex,
//     bool? interviewCompleted,
//   }) {
//     return InterviewState(
//       isLoading: isLoading ?? this.isLoading,
//       questions: questions ?? this.questions,
//       answers: answers ?? this.answers,
//       currentIndex: currentIndex ?? this.currentIndex,
//       interviewCompleted:
//       interviewCompleted ?? this.interviewCompleted,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     isLoading,
//     questions,
//     answers,
//     currentIndex,
//     interviewCompleted,
//   ];
// }

import 'package:equatable/equatable.dart';

import '../../../core/models/interview_question_model.dart';

class InterviewState extends Equatable {
  final bool isLoading;

  final List<InterviewQuestion> questions;

  final String? error;

  const InterviewState({
    this.isLoading = false,
    this.questions = const [],
    this.error,
  });

  InterviewState copyWith({
    bool? isLoading,
    List<InterviewQuestion>? questions,
    String? error,
  }) {
    return InterviewState(
      isLoading: isLoading ?? this.isLoading,
      questions: questions ?? this.questions,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    questions,
    error,
  ];
}