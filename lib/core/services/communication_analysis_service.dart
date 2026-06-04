import 'package:interview_preperation_buddy/core/models/communication_metric.dart';

class CommunicationAnalysisService {
  static const Set<String> _fillerWords = {
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

    for (final filler in _fillerWords) {
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
