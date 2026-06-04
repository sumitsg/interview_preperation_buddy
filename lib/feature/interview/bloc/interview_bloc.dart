// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../core/models/candidate_answer.dart';
// import '../../../core/services/gemini_service.dart';
// import 'interview_event.dart';
// import 'interview_state.dart';
//
// class InterviewBloc
//     extends Bloc<InterviewEvent, InterviewState> {
//   final GeminiService geminiService;
//
//   InterviewBloc(this.geminiService)
//       : super(const InterviewState()) {
//
//     on<GenerateQuestionsEvent>(
//       _generateQuestions,
//     );
//
//     on<SubmitAnswerEvent>(
//       _submitAnswer,
//     );
//   }
//
//   Future<void> _generateQuestions(
//       GenerateQuestionsEvent event,
//       Emitter<InterviewState> emit,
//       ) async {
//
//     emit(
//       state.copyWith(
//         isLoading: true,
//       ),
//     );
//
//     final questions =
//     await geminiService.generateQuestions(
//       technology: event.technology,
//       experience: event.experience,
//     );
//
//     emit(
//       state.copyWith(
//         isLoading: false,
//         questions: questions,
//       ),
//     );
//   }
//
//   void _submitAnswer(
//       SubmitAnswerEvent event,
//       Emitter<InterviewState> emit,
//       ) {
//     final currentQuestion =
//     state.questions[state.currentIndex];
//
//     final updatedAnswers = [
//       ...state.answers,
//       CandidateAnswer(
//         question: currentQuestion.question,
//         answer: event.answer,
//       ),
//     ];
//
//     final isLastQuestion =
//         state.currentIndex ==
//             state.questions.length - 1;
//
//     if (isLastQuestion) {
//       emit(
//         state.copyWith(
//           answers: updatedAnswers,
//           interviewCompleted: true,
//         ),
//       );
//     } else {
//       emit(
//         state.copyWith(
//           answers: updatedAnswers,
//           currentIndex:
//           state.currentIndex + 1,
//         ),
//       );
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/interview_repository.dart';
import 'interview_event.dart';
import 'interview_state.dart';

class InterviewBloc
    extends Bloc<InterviewEvent, InterviewState> {

  final InterviewRepository repository;

  InterviewBloc(
      this.repository,
      ) : super(const InterviewState()) {

    on<GenerateQuestionsEvent>(
      _generateQuestions,
    );
  }

  Future<void> _generateQuestions(
      GenerateQuestionsEvent event,
      Emitter<InterviewState> emit,
      ) async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          error: null,
        ),
      );

      final questions =
      await repository.generateQuestions(
        technology: event.technology,
        experience: event.experience,
      );

      emit(
        state.copyWith(
          isLoading: false,
          questions: questions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }
}