import '../../core/models/interview_question_model.dart';
import '../../core/services/gemini_service.dart';

abstract class InterviewRepository {
  Future<List<InterviewQuestion>> generateQuestions({
    required String technology,
    required String experience,
  });
}

class InterviewRepositoryImpl
    implements InterviewRepository {

  final GeminiService geminiService;

  InterviewRepositoryImpl(
      this.geminiService,
      );

  @override
  Future<List<InterviewQuestion>> generateQuestions({
    required String technology,
    required String experience,
  }) async {
    return await geminiService.generateQuestions(
      technology: technology,
      experience: experience,
    );
  }
}