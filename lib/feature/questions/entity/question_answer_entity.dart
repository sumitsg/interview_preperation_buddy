import 'package:interview_preperation_buddy/core/models/communication_metric.dart';
import 'package:interview_preperation_buddy/core/models/interview_question_model.dart';

class QuestionAnswerEntity {
  final int id;
  final String question;
  final String? answer;
  final int durationSeconds;
  final String difficulty;
  final CommunicationMetrics? metrics;

  const QuestionAnswerEntity({
    required this.id,
    required this.question,
    required this.durationSeconds,
    required this.difficulty,
    this.answer,
    this.metrics,
  });

  QuestionAnswerEntity copyWith({String? answer}) {
    return QuestionAnswerEntity(
      id: id,
      question: question,
      answer: answer ?? this.answer,
      durationSeconds: durationSeconds,
      difficulty: difficulty,
      metrics: metrics,
    );
  }

  static List<QuestionAnswerEntity> fromInterviewQuestion({required List<InterviewQuestion> data}) {
    return data
        .map(
          (e) => QuestionAnswerEntity(
            id: e.id,
            question: e.question,
            answer: null,
            durationSeconds: e.expectedTimeSeconds,
            difficulty: e.difficulty,
            metrics: null,
          ),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      // 'durationSeconds': durationSeconds,
      // 'difficulty': difficulty,
      // 'metrics': metrics?.toJson(),
    };
  }
}
