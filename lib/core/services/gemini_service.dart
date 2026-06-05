import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/env_config.dart';
import '../constants/interview_prompt_builder.dart';
import '../models/interview_evaluation.dart';
import '../models/interview_question_model.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: EnvConfig.GEMINIMODEL,
      apiKey: EnvConfig.GEMINIAPIKEY,
      generationConfig: GenerationConfig(
        temperature: 0.2,
        maxOutputTokens: 4096,
      ),
    );
  }

  // =========================
  // CLEAN RESPONSE
  // =========================
  String _cleanJson(String text) {
    return text
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();
  }

  // =========================
  // SAFE JSON PARSE
  // =========================
  Map<String, dynamic> _safeDecode(String text) {
    try {
      return jsonDecode(text);
    } catch (e) {
      throw Exception(
        "❌ Invalid JSON from Gemini:\n$text\n\nError: $e",
      );
    }
  }

  // =========================
  // GENERATE QUESTIONS
  // =========================
  Future<List<InterviewQuestion>> generateQuestions({
    required String technology,
    required String experience,
  }) async {
    final prompt = InterviewPromptBuilder.generateQuestionsPrompt(
      technology: technology,
      experience: experience,
    );

    try {
      final response = await _model.generateContent([
        Content.text(prompt),
      ]);

      final raw = response.text ?? '';
      final cleaned = _cleanJson(raw);

      debugPrint("📥 QUESTIONS RAW:\n$cleaned");

      final data = _safeDecode(cleaned);

      return (data['questions'] as List)
          .map((e) => InterviewQuestion.fromJson(e))
          .toList();

    } catch (e) {
      debugPrint("❌ generateQuestions error: $e");
      rethrow;
    }
  }

  // =========================
  // EVALUATE INTERVIEW
  // =========================
  Future<InterviewEvaluation> evaluateInterview({
    required String technology,
    required String experience,
    required String questionsAndAnswersJson,
  }) async {
    final prompt = InterviewPromptBuilder.evaluateInterviewPrompt(
      technology: technology,
      experience: experience,
      questionsAndAnswersJson: questionsAndAnswersJson,
    );

    try {
      final response = await _model.generateContent([
        Content.text(prompt),
      ]);

      final raw = response.text ?? '';
      final cleaned = _cleanJson(raw);

      debugPrint("📥 EVALUATION RAW:\n$cleaned");

      final data = _safeDecode(cleaned);

      return InterviewEvaluation.fromJson(data);

    } catch (e) {
      debugPrint("❌ evaluateInterview error: $e");
      rethrow;
    }
  }
}

String formatTime(int seconds) {
  final minutes = seconds ~/ 60;

  if (minutes == 0) {
    return '$seconds sec';
  }

  return '$minutes min';
}

