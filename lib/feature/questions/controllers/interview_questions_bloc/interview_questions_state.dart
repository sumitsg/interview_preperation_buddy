import 'package:interview_preperation_buddy/feature/questions/entity%20/question_answer_entity.dart';

class InterviewQuestionState {
  final List<QuestionAnswerEntity> questions;
  final int currentIndex;
  final bool isCompleted;

  int get currentQuestionNumber => currentIndex + 1;
  int get totalQuestions => questions.length;

  const InterviewQuestionState({
    required this.questions,
    required this.currentIndex,
    required this.isCompleted,
  });

  QuestionAnswerEntity? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  bool get isLastQuestion => currentIndex == questions.length - 1;

  InterviewQuestionState copyWith({
    List<QuestionAnswerEntity>? questions,
    int? currentIndex,
    bool? isCompleted,
    bool? isTtsInitialized,
    bool? isSpeaking,
    String? lastSpokenQuestion,
  }) {
    return InterviewQuestionState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory InterviewQuestionState.initial() {
    return const InterviewQuestionState(
      questions: [],
      currentIndex: 0,
      isCompleted: false,
    );
  }
}
