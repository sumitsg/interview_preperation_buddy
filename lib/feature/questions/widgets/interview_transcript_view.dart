import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/quesion_stt_state.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_event.dart';

class QuestionsTranscriptView extends StatefulWidget {
  const QuestionsTranscriptView({super.key});

  @override
  State<QuestionsTranscriptView> createState() => _TranscriptViewState();
}

class _TranscriptViewState extends State<QuestionsTranscriptView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<QuestionSttBloc>().state.transcript;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionSttBloc, QuestionSttState>(
      listener: (context, state) {
        if (state.transcript != _controller.text) {
          _controller.text = state.transcript;
        }
      },
      child: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.keyC, control: true):
              DoNothingIntent(),
          SingleActivator(LogicalKeyboardKey.keyV, control: true):
              DoNothingIntent(),
          SingleActivator(LogicalKeyboardKey.keyX, control: true):
              DoNothingIntent(),
          SingleActivator(LogicalKeyboardKey.keyA, control: true):
              DoNothingIntent(),

          SingleActivator(LogicalKeyboardKey.keyC, meta: true):
              DoNothingIntent(),
          SingleActivator(LogicalKeyboardKey.keyV, meta: true):
              DoNothingIntent(),
          SingleActivator(LogicalKeyboardKey.keyX, meta: true):
              DoNothingIntent(),
          SingleActivator(LogicalKeyboardKey.keyA, meta: true):
              DoNothingIntent(),
        },
        child: Actions(
          actions: {DoNothingIntent: DoNothingAction()},
          child: TextField(
            readOnly: _controller
                .text
                .isEmpty, // Allow cursor and selection only when there's text
            controller: _controller,
            enableInteractiveSelection: false,
            contextMenuBuilder: (_, __) => const SizedBox.shrink(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Your answer will appear here...',
            ),
            onChanged: (value) {
              context.read<QuestionSttBloc>().add(TranscriptUpdated(value));
            },
          ),
        ),
      ),
    );
  }
}
