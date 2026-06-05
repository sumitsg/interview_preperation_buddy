class InterviewEvaluation {
  final int overallScore;
  final String readinessLevel;

  final int technicalKnowledge;
  final int problemSolving;
  final int communication;
  final int confidence;

  final List<String> strengths;
  final List<String> improvements;
  final List<String> missedTopics;
  final List<String> nextFocus;

  final String summary;

  InterviewEvaluation({
    required this.overallScore,
    required this.readinessLevel,
    required this.technicalKnowledge,
    required this.problemSolving,
    required this.communication,
    required this.confidence,
    required this.strengths,
    required this.improvements,
    required this.missedTopics,
    required this.nextFocus,
    required this.summary,
  });

  factory InterviewEvaluation.fromJson(Map<String, dynamic> json) {
    return InterviewEvaluation(
      overallScore: json['overallScore'] ?? 0,
      readinessLevel: json['readinessLevel'] ?? '',

      technicalKnowledge: json['technicalKnowledge'] ?? 0,
      problemSolving: json['problemSolving'] ?? 0,
      communication: json['communication'] ?? 0,
      confidence: json['confidence'] ?? 0,

      strengths: (json['strengths'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],

      improvements: (json['improvements'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],

      missedTopics: (json['missedTopics'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],

      nextFocus: (json['nextFocus'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],

      summary: json['summary'] ?? '',
    );
  }
}