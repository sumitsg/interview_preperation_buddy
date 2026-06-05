class InterviewPromptBuilder {
  /// =========================
  /// QUESTION GENERATION PROMPT
  /// =========================
  static String generateQuestionsPrompt({
    required String technology,
    required String experience,
  }) {
    return '''
Act as a Senior Technical Interviewer.

Technology: $technology
Experience: $experience years

Generate exactly 5 interview questions.

Difficulty progression:

1 Easy
1 Easy-Medium
1 Medium
1 Medium-Hard
1 Hard

For each question determine a realistic expected answer time.

Rules:
- Simple definition questions: 60 sec
- Scenario questions: 90-120 sec
- Architecture questions: 120-180 sec
- Design questions: 180-240 sec

Return ONLY valid JSON.

{
  "questions":[
    {
      "id":1,
      "question":"...",
      "difficulty":"easy",
      "expectedTimeSeconds":60
    }
  ]
}
''';
  }

  /// =========================
  /// EVALUATION PROMPT
  /// =========================
  static String evaluateInterviewPrompt({
    required String technology,
    required String experience,
    required String questionsAndAnswersJson,
  }) {
    return '''
You are a Senior Technical Interviewer evaluating a mock interview.

Technology: $technology
Experience: $experience years

Interview Data:
$questionsAndAnswersJson

---

SCORING RULES:

- Score strictly from 0 to 100
- Evaluate:
  • Technical accuracy
  • Problem solving
  • Practical examples
  • Best practices
  • Communication clarity

- Penalize:
  • Wrong answers
  • Missing logic
  • Vague explanations
  • Empty answers

---

LANGUAGE POLICY (STRICT)

- Only English content is acceptable.
- If any non-English text is detected:
  • languageCheck = "NOT ACCEPTABLE"
  • That specific answer/question must be scored as 0
  • Do NOT include that answer in overall evaluation positively
- If multiple languages are mixed, still treat as NOT ACCEPTABLE

---

READINESS LEVEL:

0-39 → Not Ready
40-59 → Needs Improvement
60-79 → Interview Ready
80-100 → Strong Candidate

---

OUTPUT RULES (STRICT):

- Return ONLY valid JSON
- No markdown
- No explanation outside JSON
- All strings must be single line
- Keep output short and structured

---

RESPONSE FORMAT:

{
  "overallScore": 0,
  "readinessLevel": "",
  "technicalKnowledge": 0,
  "problemSolving": 0,
  "communication": 0,
  "confidence": 0,

  "strengths": [],
  "improvements": [],
  "missedTopics": [],
  "nextFocus": [],

  "summary": "",
}

---

FIELD LIMITS:

- strengths: max 3
- improvements: max 3
- missedTopics: max 5 keywords only (NOT sentences)
- nextFocus: max 2 keywords only (NOT sentences)
- summary: max 60 words
''';
  }
}