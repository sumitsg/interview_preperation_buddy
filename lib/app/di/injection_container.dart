import 'package:get_it/get_it.dart';
import 'package:interview_preperation_buddy/core/services/stt_service.dart';
import 'package:interview_preperation_buddy/core/services/tts_service.dart';
import 'package:interview_preperation_buddy/feature/feedback/controller/bloc/interview_evaluation_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/tts_bloc/tts_cubit.dart';
import 'package:interview_preperation_buddy/feature/questions/entity/question_answer_entity.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_bloc.dart';

import '../../core/services/gemini_service.dart';
import '../../feature/interview/bloc/interview_bloc.dart';
import '../../feature/repo/interview_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Service
  sl.registerLazySingleton(() => GeminiService());

  sl.registerFactory(() => TtsService());
  sl.registerFactory(() => SttService());

  /// Repository
  sl.registerLazySingleton<InterviewRepository>(() => InterviewRepositoryImpl(sl()));

  /// Bloc
  sl.registerFactory(() => InterviewBloc(sl()));
  sl.registerFactory(() => InterviewSetupBloc(sl()));

  sl.registerFactoryParam<InterviewQuestionBloc, List<QuestionAnswerEntity>, void>(
    (questions, _) => InterviewQuestionBloc(questions: questions),
  );

  sl.registerFactory<TtsCubit>(() => TtsCubit());
  sl.registerFactory<QuestionSttBloc>(() => QuestionSttBloc());
  sl.registerFactory<QuestionTimerBloc>(() => QuestionTimerBloc());
  sl.registerFactory<EvaluateInterviewBloc>(() => EvaluateInterviewBloc(sl()));
}
