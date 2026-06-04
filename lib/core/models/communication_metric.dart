class CommunicationMetrics {
  final int wordCount;
  final int sentenceCount;
  final int fillerWordCount;
  final double fillerRate;
  final double wordsPerMinute;
  final double averageWordsPerSentence;
  final int confidenceScore;

  const CommunicationMetrics({
    required this.wordCount,
    required this.sentenceCount,
    required this.fillerWordCount,
    required this.fillerRate,
    required this.wordsPerMinute,
    required this.averageWordsPerSentence,
    required this.confidenceScore,
  });
}
