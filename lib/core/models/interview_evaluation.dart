class InterviewEvaluation {
  final int overallScore;
  final String overallFeedback;
  final List<QuestionEvaluation> evaluations;

  InterviewEvaluation({
    required this.overallScore,
    required this.overallFeedback,
    required this.evaluations,
  });
}

class QuestionEvaluation {
  final String question;
  final String candidateAnswer;
  final String expectedAnswer;
  final int rating;
  final String feedback;

  QuestionEvaluation({
    required this.question,
    required this.candidateAnswer,
    required this.expectedAnswer,
    required this.rating,
    required this.feedback,
  });
}