import 'package:interview_preperation_buddy/core/constants/interview_constants.dart';
import 'package:interview_preperation_buddy/core/models/communication_metric.dart';

class CommunicationAnalysisService {
  CommunicationMetrics analyze({
    required String transcript,
    required Duration duration,
  }) {
    final normalized = transcript.toLowerCase().replaceAll(
      RegExp(r'[^\w\s.!?]'),
      ' ',
    );

    final words = normalized
        .split(RegExp(r'\s+'))
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final sentences = normalized
        .split(RegExp(r'[.!?]+'))
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final wordCount = words.length;

    final sentenceCount = sentences.isEmpty ? 1 : sentences.length;

    int fillerCount = 0;

    for (final filler in InterviewConstants.fillerWords) {
      final regex = RegExp(r'\b' + RegExp.escape(filler) + r'\b');

      fillerCount += regex.allMatches(normalized).length;
    }

    final fillerRate = wordCount == 0 ? 0 : (fillerCount / wordCount) * 100;

    final minutes = duration.inSeconds <= 0 ? 1 : duration.inSeconds / 60;

    final wordsPerMinute = wordCount / minutes;

    final avgWordsPerSentence = wordCount / sentenceCount;

    final confidenceScore = _calculateConfidence(
      wordsPerMinute: wordsPerMinute,
      fillerRate: fillerRate.toDouble(),
      wordCount: wordCount,
      averageWordsPerSentence: avgWordsPerSentence,
    );

    return CommunicationMetrics(
      wordCount: wordCount,
      sentenceCount: sentenceCount,
      fillerWordCount: fillerCount,
      fillerRate: fillerRate.toDouble(),
      wordsPerMinute: wordsPerMinute,
      averageWordsPerSentence: avgWordsPerSentence,
      confidenceScore: confidenceScore,
    );
  }

  int _calculateConfidence({
    required double wordsPerMinute,
    required double fillerRate,
    required int wordCount,
    required double averageWordsPerSentence,
  }) {
    double score = 100;

    // Too short answer
    if (wordCount < 20) {
      score -= 30;
    }

    // Speaking pace
    if (wordsPerMinute < 80) {
      score -= 15;
    } else if (wordsPerMinute > 180) {
      score -= 10;
    }

    // Filler words
    if (fillerRate > 10) {
      score -= 25;
    } else if (fillerRate > 5) {
      score -= 15;
    }

    // Sentence quality
    if (averageWordsPerSentence < 5) {
      score -= 10;
    }

    return score.clamp(0, 100).round();
  }
}
