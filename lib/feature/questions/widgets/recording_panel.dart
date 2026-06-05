import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';
import 'package:interview_preperation_buddy/feature/interview/widgets/recording_wave.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_state.dart';
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
          const SizedBox(height: 8),

          const Align(alignment: Alignment.center, child: _TimerWidget()),

          const SizedBox(height: 12),

          const _RecordingBanner(),

          Row(
            children: const [
              Expanded(child: _WordCountTile()),
              SizedBox(width: 12),
              Expanded(child: _StatusTile()),
            ],
          ),

          const SizedBox(height: 18),

          const _RecordingWaveSection(),

          const QuestionsTranscriptView(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _RecordingBanner extends StatelessWidget {
  const _RecordingBanner();

  @override
  Widget build(BuildContext context) {
    final isListening = context.select(
      (QuestionSttBloc bloc) => bloc.state.isListening,
    );

    if (!isListening) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.yellow.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.yellow.shade700),
      ),
      child: const Text('Please speak now so we can record your answer'),
    );
  }
}

class _WordCountTile extends StatelessWidget {
  const _WordCountTile();

  @override
  Widget build(BuildContext context) {
    final wordCount = context.select((QuestionSttBloc bloc) {
      final text = bloc.state.transcript.trim();

      if (text.isEmpty) {
        return 0;
      }

      return text.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).length;
    });

    return _StatTile(label: 'Words', value: wordCount.toString());
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

class _StatusTile extends StatelessWidget {
  const _StatusTile();

  @override
  Widget build(BuildContext context) {
    final phase = context.select((QuestionTimerBloc bloc) => bloc.state.phase);

    final isListening = context.select(
      (QuestionSttBloc bloc) => bloc.state.isListening,
    );

    final isCompleted = context.select(
      (QuestionSttBloc bloc) => bloc.state.isCompleted,
    );

    final status = switch (phase) {
      TimerPhase.idle => 'Listen for question',
      TimerPhase.thinking => 'Time to read',
      TimerPhase.answering =>
        isListening
            ? 'Recording'
            : isCompleted
            ? 'Completed'
            : 'Ready',

      TimerPhase.completed => 'Completed',
    };

    return _StatTile(label: 'Status', value: status);
  }
}

class _TimerWidget extends StatelessWidget {
  const _TimerWidget();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<QuestionTimerBloc, QuestionTimerState, String>(
      selector: (state) {
        final seconds = state.phase == TimerPhase.answering
            ? state.answerRemainingSeconds
            : state.remainingSeconds;

        final minutes = seconds ~/ 60;
        final remaining = seconds % 60;

        return '${minutes.toString().padLeft(2, '0')}:'
            '${remaining.toString().padLeft(2, '0')}';
      },
      builder: (_, time) {
        return Text(
          time,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}

class _RecordingWaveSection extends StatelessWidget {
  const _RecordingWaveSection();

  @override
  Widget build(BuildContext context) {
    final isListening = context.select(
      (QuestionSttBloc bloc) => bloc.state.isListening,
    );

    if (!isListening) {
      return const SizedBox.shrink();
    }

    return const Column(children: [RecordingWave(), SizedBox(height: 20)]);
  }
}

class RecordingPanelViewModel {
  final String transcript;
  final bool isListening;
  final bool isCompleted;
  final TimerPhase phase;

  const RecordingPanelViewModel({
    required this.transcript,
    required this.isListening,
    required this.isCompleted,
    required this.phase,
  });

  int get wordCount {
    final text = transcript.trim();
    if (text.isEmpty) return 0;

    return text.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).length;
  }

  String get status {
    switch (phase) {
      case TimerPhase.idle:
        return 'Listen for question';

      case TimerPhase.thinking:
        return 'Reading time';

      case TimerPhase.answering:
        if (isListening) return 'Recording';
        if (isCompleted) return 'Completed';
        return 'Ready';

      default:
        return '';
    }
  }
}
