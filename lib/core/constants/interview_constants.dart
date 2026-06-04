class InterviewConstants {
  /// User reviews the question before answer starts.
  static const int preparationSeconds = 15;

  /// Warning shown before skip.
  static const int warningSeconds = 15;

  /// Auto skip after warning.
  static const int autoSkipSeconds = 15;

  // Speaking Detection
  static const int silenceWarningSeconds = 10;

  static const int silenceFinalWarningSeconds = 20;

  static const int silenceTimeoutSeconds = 30;

  // Answer Quality
  static const int minAnswerWords = 10;

  static const List<String> experienceLevels = [
    '0-1 Years',
    '1-3 Years',
    '3-5 Years',
    '5-8 Years',
    '8+ Years',
  ];

  static const List<String> interviewTracks = [
    'HR / Managerial',
    'Project Management',
    'Flutter',
    'React',
    'Node.js',
    'Java Spring Boot',
    'Python Backend',
    'Full Stack Development',
    'System Design',
    'AWS',
    'DevOps',
    'Data Structures & Algorithms',
    'Software Architecture',
  ];
}
