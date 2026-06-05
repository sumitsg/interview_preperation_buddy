import 'package:interview_preperation_buddy/core/models/communication_metric.dart';

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
}
