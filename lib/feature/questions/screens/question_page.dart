import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';
import 'package:interview_preperation_buddy/core/enums/tts_state.dart';
import 'package:interview_preperation_buddy/feature/interview/widgets/recording_wave.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_event.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_state.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_event.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/quesion_stt_state.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_events.dart'
    hide SkipQuestion;
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_state.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/tts_bloc/tts_cubit.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/tts_bloc/tts_state.dart';
import 'package:interview_preperation_buddy/feature/questions/entity%20/question_answer_entity.dart';
import 'package:interview_preperation_buddy/feature/questions/widgets/question_card.dart';
import 'package:interview_preperation_buddy/shared/widgets/responsive_widget.dart';

enum QuestionUiState { ttsPlaying, readyToAnswer, recording, recordingStopped }

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [_questionChangeListener(), _ttsListener(), _timerListener()],
      child: const _QuestionView(),
    );
  }

  BlocListener<InterviewQuestionBloc, InterviewQuestionState>
  _questionChangeListener() {
    return BlocListener<InterviewQuestionBloc, InterviewQuestionState>(
      listenWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex,
      listener: (context, state) {
        final question = state.currentQuestion;

        if (question == null) return;

        context.read<QuestionTimerBloc>().add(ResetTimerFlow());

        context.read<QuestionSttBloc>().add(CancelListening());

        context.read<TtsCubit>().stop();

        context.read<TtsCubit>().speak(question.question);
      },
    );
  }

  BlocListener<TtsCubit, TtsState> _ttsListener() {
    return BlocListener<TtsCubit, TtsState>(
      listenWhen: (previous, current) =>
          previous.status == TtsStatus.speaking &&
          current.status == TtsStatus.ready,
      listener: (context, state) {
        context.read<QuestionTimerBloc>().add(StartQuestionFlow());
      },
    );
  }

  BlocListener<QuestionTimerBloc, QuestionTimerState> _timerListener() {
    return BlocListener<QuestionTimerBloc, QuestionTimerState>(
      listener: (context, state) {
        switch (state.phase) {
          case TimerPhase.skipped:
            context.read<QuestionSttBloc>().add(CancelListening());

            context.read<InterviewQuestionBloc>().add(SkipQuestion());
            break;

          case TimerPhase.completed:
            final transcript = context
                .read<QuestionSttBloc>()
                .state
                .transcript
                .trim();

            context.read<QuestionSttBloc>().add(CancelListening());

            context.read<InterviewQuestionBloc>().add(SubmitAnswer(transcript));
            break;

          default:
            break;
        }
      },
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<InterviewQuestionBloc, InterviewQuestionState>(
          builder: (context, state) {
            if (state.questions.isEmpty) {
              return const Center(child: Text('No Questions Found'));
            }

            return ResponsivePage(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    _QuestionCard(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _RecordingStatus(),
                          SizedBox(height: 24),
                          BlocBuilder<QuestionSttBloc, QuestionSttState>(
                            builder: (context, sttState) {
                              if (sttState.error != null) {
                                return Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.red.shade200,
                                        ),
                                      ),
                                      child: Text(
                                        sttState.error!,
                                        style: TextStyle(
                                          color: Colors.red.shade800,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<TtsCubit, TtsState>(
                            builder: (context, ttsState) {
                              final showAnswerUI =
                                  ttsState.status != TtsStatus.speaking;

                              if (!showAnswerUI) {
                                return const SizedBox.shrink();
                              }

                              return Column(
                                children: const [
                                  _TimerWidget(),
                                  SizedBox(height: 40),
                                  _TranscriptView(),
                                  SizedBox(height: 24),
                                  RecordingWaveformWidget(),
                                ],
                              );
                            },
                          ),

                          SizedBox(height: 32),
                          _StatsWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard();

  @override
  Widget build(BuildContext context) {
    final questionState = context.select(
      (InterviewQuestionBloc bloc) => bloc.state,
    );

    if (questionState.currentQuestion == null) {
      return const SizedBox.shrink();
    }

    return QuestionCard(
      questionNumber: questionState.currentQuestionNumber,
      totalQuestions: questionState.totalQuestions,
      question: questionState.currentQuestion!,
    );
  }
}

class InterviewFlowListener extends StatelessWidget {
  final Widget child;

  const InterviewFlowListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<InterviewQuestionBloc, InterviewQuestionState>(
          listenWhen: (previous, current) =>
              previous.currentIndex != current.currentIndex,
          listener: (context, state) {
            final question = state.currentQuestion;

            if (question == null) return;

            context.read<TtsCubit>().stop();

            context.read<QuestionSttBloc>().add(CancelListening());

            context.read<TtsCubit>().speak(question.question);
            Future.delayed(const Duration(milliseconds: 200));

            context.read<QuestionSttBloc>().add(
              const StartListening(listenDuration: 300),
            );
          },
        ),
      ],
      child: child,
    );
  }
}

class InterviewTranscriptView extends StatelessWidget {
  const InterviewTranscriptView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<QuestionSttBloc, QuestionSttState, String>(
      selector: (state) => state.transcript,
      builder: (_, transcript) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: SelectableText(
            transcript.isEmpty ? 'Your answer will appear here...' : transcript,
          ),
        );
      },
    );
  }
}

class _RecordingStatus extends StatelessWidget {
  const _RecordingStatus();

  @override
  Widget build(BuildContext context) {
    final isListening = context.select(
      (QuestionSttBloc bloc) => bloc.state.isListening,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 4,
            backgroundColor: isListening ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(isListening ? 'RECORDING' : 'PAUSED'),
        ],
      ),
    );
  }
}

class InterviewStatsWidget extends StatelessWidget {
  const InterviewStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final transcript = context.select(
      (QuestionSttBloc bloc) => bloc.state.transcript,
    );

    final wordCount = transcript
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text('Word Count'),
                const SizedBox(height: 4),
                Text('$wordCount'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TranscriptView extends StatefulWidget {
  const _TranscriptView();

  @override
  State<_TranscriptView> createState() => _TranscriptViewState();
}

class _TranscriptViewState extends State<_TranscriptView> {
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

class _StatsWidget extends StatelessWidget {
  const _StatsWidget();

  @override
  Widget build(BuildContext context) {
    final transcript = context.select(
      (QuestionSttBloc bloc) => bloc.state.transcript,
    );

    final words = transcript
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .length;

    return Text('Words: $words');
  }
}

class _TimerWidget extends StatelessWidget {
  const _TimerWidget();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<QuestionTimerBloc, QuestionTimerState, int>(
      selector: (state) {
        return state.phase == TimerPhase.answering
            ? state.answerRemainingSeconds
            : state.remainingSeconds;
      },
      builder: (_, seconds) {
        final minutes = seconds ~/ 60;
        final remainingSeconds = seconds % 60;

        return Column(
          children: [
            Text(
              '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
            ),
          ],
        );
      },
    );
  }
}

class RecordingWaveformWidget extends StatelessWidget {
  const RecordingWaveformWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 120, child: RecordingWave());
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

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
                onPressed: () => _onSubmit(context),
                child: const Text('Submit'),
              ),

            const Spacer(),

            TextButton(
              onPressed: () => _onSkip(context),
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
  }

  void _onRetry(BuildContext context) {
    context.read<QuestionSttBloc>().add(CancelListening());

    context.read<QuestionSttBloc>().add(
      const StartListening(listenDuration: 300),
    );
  }

  void _onSubmit(BuildContext context) {
    final transcript = context.read<QuestionSttBloc>().state.transcript.trim();

    context.read<QuestionSttBloc>().add(StopListening());
    context.read<InterviewQuestionBloc>().add(SubmitAnswer(transcript));
    if (context.read<InterviewQuestionBloc>().state.currentQuestionNumber ==
        5) {
      context.read<InterviewQuestionBloc>().state.questions.map(
        (e) => debugPrint('Question: ${e.question}, Answer: ${e.answer}'),
      );
    }
  }

  void _onSkip(BuildContext context) {
    context.read<TtsCubit>().stop();

    context.read<QuestionSttBloc>().add(CancelListening());

    context.read<InterviewQuestionBloc>().add(SkipQuestion());
  }
}
