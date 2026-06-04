class InterviewQuestion {
  final int id;
  final String question;

  InterviewQuestion({
    required this.id,
    required this.question,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    return InterviewQuestion(
      id: json['id'],
      question: json['question'],
    );
  }
}