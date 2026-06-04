import 'package:get_it/get_it.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_bloc.dart';

import '../../core/services/gemini_service.dart';
import '../../feature/interview/bloc/interview_bloc.dart';
import '../../feature/repo/interview_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Service
  sl.registerLazySingleton(() => GeminiService());

  /// Repository
  sl.registerLazySingleton<InterviewRepository>(() => InterviewRepositoryImpl(sl()));

  /// Bloc
  sl.registerFactory(() => InterviewBloc(sl()));
  sl.registerFactory(() => InterviewSetupBloc());
}
