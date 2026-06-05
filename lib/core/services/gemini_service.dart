import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../config/env_config.dart';
import '../constants/interview_prompt_builder.dart';
import '../models/interview_evaluation.dart';
import '../models/interview_question_model.dart';

enum GeminiTaskType {
  generateQuestions,
  evaluateInterview,
}

class GeminiService {
  late final GenerativeModel _baseModel;

  GeminiService() {
    _baseModel = GenerativeModel(
      model: EnvConfig.GEMINIMODEL,
      apiKey: EnvConfig.GEMINIAPIKEY,
    );
  }

  // =========================
  // MODEL FACTORY (NEW)
  // =========================
  GenerativeModel _buildModel(double temperature) {
    return GenerativeModel(
      model: EnvConfig.GEMINIMODEL,
      apiKey: EnvConfig.GEMINIAPIKEY,
      generationConfig: GenerationConfig(
        temperature: temperature,
        maxOutputTokens: 4096,
      ),
    );
  }

  GenerativeModel getModel(GeminiTaskType type) {
    switch (type) {
      case GeminiTaskType.generateQuestions:
        return _buildModel(0.7);

      case GeminiTaskType.evaluateInterview:
        return _buildModel(0.2);
    }
  }

  // =========================
  // RETRY WRAPPER
  // =========================
  Future<T> _withRetry<T>(
      Future<T> Function() task, {
        int maxRetries = 3,
      }) async {
    int attempt = 0;

    while (true) {
      try {
        return await task();
      } catch (e) {
        attempt++;

        final is503 = e.toString().contains("503");
        final isLast = attempt >= maxRetries;

        if (!is503 || isLast) {
          rethrow;
        }

        final delay = Duration(seconds: 1 << (attempt - 1));
        debugPrint("Retrying AI call... attempt $attempt");

        await Future.delayed(delay);
      }
    }
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
      throw Exception("Invalid JSON:\n$text\nError: $e");
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

    final model = getModel(GeminiTaskType.generateQuestions);

    try {
      final response = await _withRetry(() async {
        return await model.generateContent([
          Content.text(prompt),
        ]);
      });

      final raw = response.text ?? '';
      final cleaned = _cleanJson(raw);

      debugPrint("QUESTIONS RAW:\n$cleaned");

      final data = _safeDecode(cleaned);

      return (data['questions'] as List)
          .map((e) => InterviewQuestion.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("generateQuestions error: $e");
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

    final model = getModel(GeminiTaskType.evaluateInterview);

    try {
      final response = await _withRetry(() async {
        return await model.generateContent([
          Content.text(prompt),
        ]);
      });

      final raw = response.text ?? '';
      final cleaned = _cleanJson(raw);

      debugPrint("EVALUATION RAW:\n$cleaned");

      final data = _safeDecode(cleaned);

      return InterviewEvaluation.fromJson(data);
    } catch (e) {
      debugPrint("evaluateInterview error: $e");

      return InterviewEvaluation(
        overallScore: 0,
        strengths: [],
        improvements: [],
        missedTopics: [],
        nextFocus: [],
        summary: "AI service is temporarily unavailable. Please try again later.",
        readinessLevel: '',
        technicalKnowledge: 0,
        problemSolving: 0,
        communication: 0,
        confidence: 0,
      );
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