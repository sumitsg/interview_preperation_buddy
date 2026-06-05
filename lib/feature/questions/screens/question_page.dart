import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/core/enums/answer_phase.dart';
import 'package:interview_preperation_buddy/core/enums/tts_state.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_bloc.dart';
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

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  var _hasSpokenInitialQuestion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndSpeakInitialQuestion();
    });
  }

  @override
  void dispose() {
    super.dispose();
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
    if (!mounted) return;
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

        _resetQuestionState();

        await context.read<TtsCubit>().stop();

        if (!context.mounted) return;

        await context.read<TtsCubit>().speak(question.question);
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
        debugPrint(
          'TimerListener => phase=${state.phase}, isRecording=${state.hasSpoken}',
        );
        switch (state.phase) {
          case TimerPhase.answering:
            final sttState = context.read<QuestionSttBloc>().state;

            if (!sttState.isListening) {
              context.read<QuestionSttBloc>().add(
                const StartListening(listenDuration: 300),
              );
            }
            break;

          default:
            break;
        }
      },
    );
  }

  void _resetQuestionState() {
    context.read<QuestionTimerBloc>().add(const ResetTimerFlow());

    context.read<QuestionSttBloc>().add(CancelListening());

    context.read<QuestionSttBloc>().add(const ResetStt());
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
