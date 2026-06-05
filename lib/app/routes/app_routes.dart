import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/app/di/injection_container.dart';
import 'package:interview_preperation_buddy/feature/interview/ui/interview_setup_page.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/tts_bloc/tts_cubit.dart';
import 'package:interview_preperation_buddy/feature/questions/entity%20/question_answer_entity.dart';
import 'package:interview_preperation_buddy/feature/questions/screens/question_page.dart';

class AppRoutes {
  static const String interview = '/';
  static const String questions = '/questions';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.interview:
        return MaterialPageRoute(
          builder: (_) => const InterviewSetupPage(),
          settings: settings,
        );

      case AppRoutes.questions:
        final args = settings.arguments as List<QuestionAnswerEntity>;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<TtsCubit>(create: (_) => sl<TtsCubit>()),
              BlocProvider<QuestionSttBloc>(
                create: (_) => sl<QuestionSttBloc>(),
              ),
              BlocProvider<QuestionTimerBloc>(
                create: (_) => sl<QuestionTimerBloc>(),
              ),
              BlocProvider<InterviewQuestionBloc>(
                create: (_) => sl<InterviewQuestionBloc>(param1: args),
              ),
            ],
            child: const QuestionPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
