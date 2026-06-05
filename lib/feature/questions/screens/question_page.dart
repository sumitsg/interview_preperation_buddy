import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';
import 'package:interview_preperation_buddy/core/enums/tts_state.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/pages/evaluation_page.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_event.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_state.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_event.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/quesion_stt_state.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_events.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_state.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/tts_bloc/tts_cubit.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/tts_bloc/tts_state.dart';
import 'package:interview_preperation_buddy/feature/questions/widgets/footer_actions.dart';
import 'package:interview_preperation_buddy/feature/questions/widgets/question_card.dart';
import 'package:interview_preperation_buddy/feature/questions/widgets/recording_panel.dart';
import 'package:interview_preperation_buddy/shared/widgets/responsive_widget.dart';

enum QuestionUiState { ttsPlaying, readyToAnswer, recording, recordingStopped }

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  var _hasSpokenInitialQuestion = false;
  bool _warningDialogVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndSpeakInitialQuestion();
    });

    // final config = context.read<InterviewSetupBloc>().state.interviewConfig;
    // final technology = config['technology'] as String;
    // final experience = config['experience'] as String;
    // final focusArea = config['focusArea'] as String;
    // //
    // debugPrint('Interview Config - Technology: $technology, Experience: $experience, Focus Area: $focusArea');
  }

  Future<void> _initializeAndSpeakInitialQuestion() async {
    if (_hasSpokenInitialQuestion) return;

    final ttsCubit = context.read<TtsCubit>();
    final interviewBloc = context.read<InterviewQuestionBloc>();
    final question = interviewBloc.state.currentQuestion;

    if (question == null) return;

    await ttsCubit.initialize();

    if (!mounted) return;

    if (ttsCubit.state.status != TtsStatus.ready) {
      return;
    }

    context.read<QuestionTimerBloc>().add(ResetTimerFlow());
    context.read<QuestionSttBloc>().add(CancelListening());

    await ttsCubit.speak(question.question);
    _hasSpokenInitialQuestion = true;
  }

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
      listener: (context, state) async {
        final question = state.currentQuestion;

        if (question == null) return;

        context.read<QuestionTimerBloc>().add(const ResetTimerFlow());

        context.read<QuestionSttBloc>().add(CancelListening());

        await context.read<TtsCubit>().stop().then((_) async {
          if (context.mounted) {
            await context.read<TtsCubit>().speak(question.question);
          }
        });
      },
    );
  }

  BlocListener<TtsCubit, TtsState> _ttsListener() {
    return BlocListener<TtsCubit, TtsState>(
      listenWhen: (previous, current) =>
          previous.status == TtsStatus.speaking &&
          current.status == TtsStatus.completed,
      listener: (context, state) {
        context.read<QuestionTimerBloc>().add(const StartQuestionFlow());
      },
    );
  }

  BlocListener<QuestionTimerBloc, QuestionTimerState> _timerListener() {
    return BlocListener<QuestionTimerBloc, QuestionTimerState>(
      listenWhen: (previous, current) => previous.phase != current.phase,
      listener: (context, state) async {
        switch (state.phase) {
          case TimerPhase.idle:
            final question = context
                .read<InterviewQuestionBloc>()
                .state
                .currentQuestion;

            if (question == null) return;

            context.read<QuestionSttBloc>().add(
              const StartListening(listenDuration: 300),
            );

            context.read<QuestionTimerBloc>().add(
              StartRecording(Duration(seconds: question.durationSeconds)),
            );

            break;

          case TimerPhase.speechWarning:
            if (_warningDialogVisible) return;

            _warningDialogVisible = true;

            context.read<QuestionSttBloc>().add(StopListening());

            await _showSpeechWarningDialog(context);

            _warningDialogVisible = false;

            break;

          case TimerPhase.skipped:
            if (_warningDialogVisible) {
              Navigator.pop(context);
            }
            await _resetInterviewState(context);

            context.read<InterviewQuestionBloc>().add(
              SkipInterviewQuestionQuestion(),
            );

            break;

          case TimerPhase.completed:
            final transcript = context
                .read<QuestionSttBloc>()
                .state
                .transcript
                .trim();

            await _resetInterviewState(context);

            context.read<InterviewQuestionBloc>().add(SubmitAnswer(transcript));

            // call the api when on last page
            if (context
                    .read<InterviewQuestionBloc>()
                    .state
                    .currentQuestionNumber ==
                5) {
              //
              final config = context
                  .read<InterviewSetupBloc>()
                  .state
                  .interviewConfig;
              final technology = config['technology'] as String;
              final experience = config['experience'] as String;
              final focusArea = config['focusArea'] as String;
              //
              log(
                'Interview Config - Technology: $technology, Experience: $experience, Focus Area: $focusArea',
              );

              //
              context.read<InterviewQuestionBloc>().state.questions.map(
                (e) =>
                    debugPrint('Question: ${e.question}, Answer: ${e.answer}'),
              );

              log(
                "Navigating to evaluation page with collected data...${context.read<InterviewQuestionBloc>().state.questions}",
              );

              Navigator.pushNamed(
                context,
                '/evaluation',
                arguments: EvaluationPageArgs(
                  technology: technology,
                  experience: experience,
                  questionAndAnswer: context
                      .read<InterviewQuestionBloc>()
                      .state
                      .questions,
                ),
              );
            }

            break;

          default:
            break;
        }
      },
    );
  }

  Future<void> _showSpeechWarningDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Time\'s almost up!'),
          content: const Text('Please wrap up your answer.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                context.read<QuestionTimerBloc>().add(const SkipQuestion());
              },
              child: const Text('Skip'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);

                context.read<QuestionSttBloc>().add(
                  const StartListening(listenDuration: 300),
                );

                context.read<QuestionTimerBloc>().add(
                  const ContinueRecording(),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        );
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
                    QuestionCard(),
                    SizedBox(height: 24),
                    RecordingPanel(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                          SizedBox(height: 32),
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
      bottomNavigationBar: const QuestionBottomBar(),
    );
  }
}

Future<void> _resetInterviewState(BuildContext context) async {
  await context.read<TtsCubit>().stop();

  context.read<QuestionSttBloc>().add(CancelListening());

  context.read<QuestionSttBloc>().add(const ResetStt());

  context.read<QuestionTimerBloc>().add(const ResetTimerFlow());
}
