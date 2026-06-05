import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';
import 'package:interview_preperation_buddy/core/enums/tts_state.dart';
import 'package:interview_preperation_buddy/feature/interview/widgets/recording_wave.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_state.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/tts_bloc/tts_cubit.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/tts_bloc/tts_state.dart';
import 'package:interview_preperation_buddy/feature/questions/widgets/interview_transcript_view.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_card.dart';

class RecordingPanel extends StatelessWidget {
  const RecordingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RecordingStatus(isListening: true),
          const SizedBox(height: 20),

          Align(alignment: Alignment.center, child: _TimerWidget()),

          BlocBuilder<TtsCubit, TtsState>(
            builder: (context, ttsState) {
              final showAnswerUI = ttsState.status != TtsStatus.speaking;

              if (!showAnswerUI) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  _StatTile(label: 'Words', value: 0.toString()),
                  RecordingWave(),
                  SizedBox(height: 40),
                  QuestionsTranscriptView(),
                  SizedBox(height: 24),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RecordingStatus extends StatelessWidget {
  const _RecordingStatus({required this.isListening});

  final bool isListening;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isListening
            ? Colors.green.withOpacity(.12)
            : Colors.grey.withOpacity(.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 4,
            backgroundColor: isListening ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            isListening ? 'RECORDING' : 'PAUSED',
            style: TextStyle(
              color: isListening ? Colors.green.shade700 : Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}

class _TimerWidget extends StatelessWidget {
  _TimerWidget();

  late int remaining;

  String get formatted {
    final min = remaining ~/ 60;
    final sec = remaining % 60;

    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<QuestionTimerBloc, QuestionTimerState, int>(
      selector: (state) {
        return state.phase == TimerPhase.answering
            ? state.answerRemainingSeconds
            : state.remainingSeconds;
      },
      builder: (_, seconds) {
        remaining = seconds;

        return Text(
          formatted,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
