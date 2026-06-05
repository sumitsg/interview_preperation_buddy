class InterviewQuestion {
  final int id;
  final String question;
  final String difficulty;
  final int expectedTimeSeconds;

  InterviewQuestion({
    required this.id,
    required this.question,
    required this.difficulty,
    required this.expectedTimeSeconds,
  });

  factory InterviewQuestion.fromJson(
      Map<String, dynamic> json,
      ) {
    return InterviewQuestion(
      id: json['id'],
      question: json['question'],
      difficulty: json['difficulty'],
      expectedTimeSeconds:
      json['expectedTimeSeconds'],
    );
  }
}