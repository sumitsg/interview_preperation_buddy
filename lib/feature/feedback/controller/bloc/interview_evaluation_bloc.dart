import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/feature/repo/interview_repository.dart';

import 'interview_evaluation_event.dart';
import 'interview_evaluation_state.dart';

class EvaluateInterviewBloc extends Bloc<EvaluateInterviewEvent, EvaluateInterviewState> {
  final InterviewRepository repository;

  EvaluateInterviewBloc(this.repository) : super(const EvaluateInterviewState()) {
    on<EvaluateInterview>(_generateQuestions);
  }

  Future<void> _generateQuestions(EvaluateInterview event, Emitter<EvaluateInterviewState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final evaluationData = await repository.evaluateInterview(
        technology: event.technology,
        experience: event.experience,
        questionsAndAnswersJson: event.questionAndAnswer,
      );

      emit(state.copyWith(isLoading: false, evaluation: evaluationData));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString(), evaluation: null));
    }
  }
}
