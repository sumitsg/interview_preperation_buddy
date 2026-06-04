import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/env_config.dart';
import '../models/interview_question_model.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: EnvConfig.GEMINIMODEL,
      apiKey: EnvConfig.GEMINIAPIKEY,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 2048,
      ),
    );
  }

  Future<List<InterviewQuestion>> generateQuestions({
    required String technology,
    required String experience,
  }) async {
    final prompt = '''
Act as a Senior Technical Interviewer.

Technology: $technology
Experience: $experience years

Generate exactly 5 interview questions.

Return valid JSON only.

{
  "questions":[
    {
      "id":1,
      "question":"..."
    }
  ]
}
''';

    final response = await _model.generateContent([
      Content.text(prompt),
    ]);
    print('RAW RESPONSE:------------');
    print(response.text);
    final jsonString =
    (response.text ?? '')
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final Map<String, dynamic> data =
    jsonDecode(jsonString);

    return (data['questions'] as List)
        .map(
          (e) => InterviewQuestion.fromJson(e),
    )
        .toList();
  }
}