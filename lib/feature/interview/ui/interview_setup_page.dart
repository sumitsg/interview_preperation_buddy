import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../app/di/injection_container.dart';
import '../../repo/interview_repository.dart';
import '../bloc/interview_bloc.dart';
import '../bloc/interview_event.dart';
import '../bloc/interview_state.dart';
import 'interview_page.dart';

class InterviewSetupPage extends StatefulWidget {
  const InterviewSetupPage({super.key});

  @override
  State<InterviewSetupPage> createState() =>
      _InterviewSetupPageState();
}

class _InterviewSetupPageState
    extends State<InterviewSetupPage> {

  final _technologyController =
  TextEditingController();

  final _experienceController =
  TextEditingController();

  @override
  void dispose() {
    _technologyController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _startInterview() {
    final technology =
    _technologyController.text.trim();

    final experience =
    _experienceController.text.trim();

    if (technology.isEmpty ||
        experience.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields',
          ),
        ),
      );
      return;
    }

    context.read<InterviewBloc>().add(
      GenerateQuestionsEvent(
        technology: technology,
        experience: experience,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Interviewer',
        ),
      ),
      body: BlocConsumer<
          InterviewBloc,
          InterviewState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  state.error!,
                ),
              ),
            );
          }

          if (state.questions.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const InterviewPage(),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding:
            const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [

                const SizedBox(height: 24),

                TestEvaluateButton(),
                TextField(
                  controller:
                  _technologyController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    'Technology',
                    hintText:
                    'Flutter',
                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller:
                  _experienceController,
                  keyboardType:
                  TextInputType.number,
                  decoration:
                  const InputDecoration(
                    labelText:
                    'Experience (Years)',
                    hintText:
                    '4.6',
                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                    state.isLoading
                        ? null
                        : _startInterview,
                    child: state.isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child:
                      CircularProgressIndicator(),
                    )
                        : const Text(
                      'Start Interview',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class TestEvaluateButton extends StatelessWidget {
  const TestEvaluateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final repo = sl<InterviewRepository>();

        const testJson = '''
{
  "questions": [
    {
      "id": 1,
      "question": "Explain StatelessWidget vs StatefulWidget in Flutter.",
      "answer": "StatelessWidget is immutable and used when UI does not change."
    },
    {
      "id": 2,
      "question": "What is BuildContext in Flutter?",
      "answer": "Used to locate widgets in widget tree."
    },
    {
      "id": 3,
      "question": "How would you build a list UI in Flutter?",
      "answer": "list UI ko hum listview aur listview.builder use kr skte h aur bhut sare chije use kr skte h"
    },
    {
      "id": 4,
      "question": "How do you fetch API data in Flutter?",
      "answer": ""
    },
    {
      "id": 5,
      "question": "How navigation works in Flutter?",
      "answer": "iske liye Navigator.push and pop. kaam krta h "
    }
  ]
}
''';

        try {
          final result = await repo.evaluateInterview(
            technology: "Flutter",
            experience: "4.6",
            questionsAndAnswersJson: testJson,
          );

          debugPrint("OVERALL SCORE: ${result.overallScore}");
          debugPrint("LEVEL: ${result.confidence}");
          debugPrint("FEEDBACK: ${result.nextFocus}");

        } catch (e) {
          debugPrint("ERROR: $e");
        }
      },
      child: const Text("Test AI Evaluation"),
    );
  }
}