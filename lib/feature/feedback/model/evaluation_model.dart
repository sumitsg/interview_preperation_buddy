class EvaluationModel {
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

  const EvaluationModel({
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
}
