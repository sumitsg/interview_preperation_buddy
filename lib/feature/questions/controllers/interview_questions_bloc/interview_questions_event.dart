import 'package:interview_preperation_buddy/feature/questions/entity%20/question_answer_entity.dart';

abstract class InterviewQuestionEvent {}

class LoadQuestions extends InterviewQuestionEvent {
  final List<QuestionAnswerEntity> questions;

  LoadQuestions(this.questions);
}

class SubmitAnswer extends InterviewQuestionEvent {
  final String answer;

  SubmitAnswer(this.answer);
}

class SkipQuestion extends InterviewQuestionEvent {}
