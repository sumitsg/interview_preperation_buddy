class InterviewConstants {
  /// User reviews the question before answer starts.
  static const int preparationSeconds = 15;

  /// Warning shown before skip.
  static const int warningSeconds = 15;

  /// Auto skip after warning.
  static const int autoSkipSeconds = 15;

  // Speaking Detection
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

  static const Set<String> fillerWords = {
    // Basic hesitation sounds
    'um',
    'uh',
    'umm',
    'uhh',
    'hmm',
    'hmmm',
    'erm',
    'ah',
    'eh',
    'mm',
    'mmm',

    // Common fillers
    'like',
    'actually',
    'basically',
    'literally',
    'seriously',
    'obviously',
    'essentially',
    'generally',
    'technically',
    'simply',

    // Multi-word fillers
    'you know',
    'i mean',
    'sort of',
    'kind of',
    'more or less',
    'at the end of the day',
    'if that makes sense',
    'you see',
    'to be honest',
    'honestly',
    'well',
    'so yeah',
    'and yeah',
    'right',
    'okay',
    'ok',
    'alright',

    // Thinking / stalling phrases
    'let me think',
    'give me a second',
    'one second',
    'just a second',
    'how do i put this',
    'how should i say',
    'what i want to say is',
    'what i mean is',
    'let me explain',
    'let me see',
    'let me recall',

    // Weak confidence indicators
    'i think',
    'i guess',
    'maybe',
    'probably',
    'perhaps',
    'possibly',
    'i suppose',
    'i believe',
    'i would say',
    'i would think',
    'i am not sure',
    'not sure',
    'kind of think',
    'sort of think',

    // Repetitive connectors
    'so',
    'and',
    'but',
    'then',
    'so basically',
    'so actually',
    'and then',
    'and so',
    'right so',

    // Interview-specific fillers
    'from my perspective',
    'as such',
    'in a way',
    'somewhat',
    'you could say',
    'to some extent',
    'in my opinion',
    'according to me',
  };
}
