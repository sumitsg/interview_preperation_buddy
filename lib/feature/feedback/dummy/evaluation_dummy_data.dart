import 'package:interview_preperation_buddy/feature/feedback/model/evaluation_model.dart';

const evaluationDummy = EvaluationModel(
  overallScore: 24,
  readinessLevel: 'Not Ready',

  technicalKnowledge: 20,
  problemSolving: 20,
  communication: 30,
  confidence: 20,

  strengths: ['Identified basic concepts'],

  improvements: [
    'Deepen understanding of core Flutter concepts',
    'Provide comprehensive answers with details and examples',
    'Address critical areas like API integration',
  ],

  missedTopics: ['StatefulWidget lifecycle', 'setState', 'ListView.builder', 'HTTP client', 'Navigator 2.0'],

  nextFocus: ['State management', 'Networking'],

  summary:
      'The candidate provided very basic and often incomplete answers to fundamental Flutter questions. A critical gap was the inability to explain API data fetching. Responses lacked the depth and best practices expected from a developer with 4.6 years of experience.',
);
