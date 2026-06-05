import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_event.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_state.dart';
import 'package:interview_preperation_buddy/feature/questions/entity%20/question_answer_entity.dart';

class InterviewQuestionBloc
    extends Bloc<InterviewQuestionEvent, InterviewQuestionState> {
  InterviewQuestionBloc({required List<QuestionAnswerEntity> questions})
    : super(
        InterviewQuestionState(
          questions: questions,
          currentIndex: 0,
          isCompleted: false,
        ),
      ) {
    on<LoadQuestions>(_onLoadQuestions);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<SkipQuestion>(_onSkipQuestion);
  }

  void _onLoadQuestions(
    LoadQuestions event,
    Emitter<InterviewQuestionState> emit,
  ) {
    emit(
      state.copyWith(
        questions: event.questions,
        currentIndex: 0,
        isCompleted: false,
      ),
    );
  }

  Future<void> _onSubmitAnswer(
    SubmitAnswer event,
    Emitter<InterviewQuestionState> emit,
  ) async {
    if (state.isCompleted) return;

    final updatedQuestions = List<QuestionAnswerEntity>.from(state.questions);

    updatedQuestions[state.currentIndex] = updatedQuestions[state.currentIndex]
        .copyWith(answer: event.answer);

    await _moveNext(emit, updatedQuestions);
  }

  Future<void> _onSkipQuestion(
    SkipQuestion event,
    Emitter<InterviewQuestionState> emit,
  ) async {
    if (state.isCompleted) return;

    final updatedQuestions = List<QuestionAnswerEntity>.from(state.questions);

    updatedQuestions[state.currentIndex] = updatedQuestions[state.currentIndex]
        .copyWith(answer: null);

    await _moveNext(emit, updatedQuestions);
  }

  Future<void> _moveNext(
    Emitter<InterviewQuestionState> emit,
    List<QuestionAnswerEntity> updatedQuestions,
  ) async {
    final nextIndex = state.currentIndex + 1;

    if (nextIndex >= updatedQuestions.length) {
      emit(
        state.copyWith(
          questions: updatedQuestions,
          isCompleted: true,
          isSpeaking: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        questions: updatedQuestions,
        currentIndex: nextIndex,
        isSpeaking: false,
      ),
    );
  }
}
