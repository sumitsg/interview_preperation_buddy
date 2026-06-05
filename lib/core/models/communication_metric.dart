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

  Map<String, dynamic> toJson() {
    return {
      'wordCount': wordCount,
      'sentenceCount': sentenceCount,
      'fillerWordCount': fillerWordCount,
      'fillerRate': fillerRate,
      'wordsPerMinute': wordsPerMinute,
      'averageWordsPerSentence': averageWordsPerSentence,
      'confidenceScore': confidenceScore,
    };
  }
}
