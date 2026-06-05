import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/core/enums/tts_state.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/pages/evaluation_page.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_event.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/quesion_stt_state.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_event.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_events.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/tts_bloc/tts_cubit.dart';
import 'package:interview_preperation_buddy/feature/questions/entity/question_answer_entity.dart';

bool _questionTransitionInProgress = false;

class QuestionBottomBar extends StatelessWidget {
  const QuestionBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ttsState = context.watch<TtsCubit>().state;
    final sttState = context.watch<QuestionSttBloc>().state;

    final isTtsPlaying = ttsState.status == TtsStatus.speaking;
    final isListening = sttState.isListening;

    final showStart =
        !isTtsPlaying && !isListening && sttState.transcript.isEmpty;

    final showStop = !isTtsPlaying && isListening;

    final showSubmit =
        !isTtsPlaying && !isListening && sttState.transcript.trim().isNotEmpty;

    final showRestart =
        !isTtsPlaying && (isListening || sttState.transcript.isNotEmpty);

    final showRetry = !isTtsPlaying && sttState.status == SttBlocStatus.error;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (showRestart)
              OutlinedButton(
                onPressed: () => _onRestart(context),
                child: const Text('Restart'),
              ),

            const Spacer(),

            if (showRetry)
              FilledButton(
                onPressed: () => _onRetry(context),
                child: const Text('Retry mic'),
              ),

            if (showStart)
              FilledButton(
                onPressed: () => _onStart(
                  context,
                  context.read<InterviewQuestionBloc>().state.currentQuestion!,
                ),
                child: const Text('Start'),
              ),

            if (showStop)
              FilledButton(
                onPressed: () => _onStop(context),
                child: const Text('Stop'),
              ),

            if (showSubmit)
              FilledButton(
                onPressed: () => _submitCurrentAnswer(context),
                child: const Text('Submit'),
              ),

            const Spacer(),

            TextButton(
              onPressed: () => _submitCurrentAnswer(context, skipped: true),
              child: const Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }

  void _onStart(BuildContext context, QuestionAnswerEntity question) {
    context.read<TtsCubit>().stop();
    Future.delayed(const Duration(milliseconds: 200));
    context.read<QuestionSttBloc>().add(
      const StartListening(listenDuration: 300),
    );

    context.read<QuestionTimerBloc>().add(
      StartRecording(Duration(seconds: question.durationSeconds)),
    );
  }

  void _onRestart(BuildContext context) {
    context.read<QuestionSttBloc>().add(CancelListening());

    context.read<QuestionSttBloc>().add(
      const StartListening(listenDuration: 300),
    );
  }

  void _onStop(BuildContext context) {
    context.read<QuestionSttBloc>().add(StopListening());
    context.read<QuestionTimerBloc>().add(const StopRecordingTimer());
  }

  void _onRetry(BuildContext context) {
    context.read<QuestionSttBloc>().add(CancelListening());

    context.read<QuestionSttBloc>().add(
      const StartListening(listenDuration: 300),
    );
  }

  Future<void> _submitCurrentAnswer(
    BuildContext context, {
    bool skipped = false,
  }) async {
    if (_questionTransitionInProgress || !context.mounted) return;

    _questionTransitionInProgress = true;

    try {
      final sttBloc = context.read<QuestionSttBloc>();
      final interviewBloc = context.read<InterviewQuestionBloc>();

      sttBloc.add(StopListening());

      await Future.delayed(const Duration(milliseconds: 300));

      if (!context.mounted) return;

      final transcript = skipped ? '' : sttBloc.state.transcript.trim();

      await _resetInterviewState(context);

      if (!context.mounted) return;

      interviewBloc.add(SubmitAnswer(transcript));

      await Future.delayed(const Duration(milliseconds: 100));

      if (!context.mounted) return;

      final state = interviewBloc.state;

      if (!state.isLastQuestion) return;

      final config = context.read<InterviewSetupBloc>().state.interviewConfig;

      final technology = config['technology'] as String;
      final experience = config['experience'] as String;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/evaluation',
        (_) => false,
        arguments: EvaluationPageArgs(
          technology: technology,
          experience: experience,
          questionAndAnswer: state.questions,
        ),
      );
    } finally {
      _questionTransitionInProgress = false;
    }
  }

  Future<void> _resetInterviewState(BuildContext context) async {
    await context.read<TtsCubit>().stop();
    if (!context.mounted) return;
    context.read<QuestionSttBloc>().add(CancelListening());

    context.read<QuestionSttBloc>().add(const ResetStt());
  }
}
