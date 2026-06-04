import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/app/themes/app_theme.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/pages/evaluation_page.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_bloc.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/pages/interview_setup_page.dart';
import '../../feature/interview/bloc/interview_bloc.dart';

import '../di/injection_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InterviewBloc>(create: (_) => sl<InterviewBloc>()),
        BlocProvider<InterviewSetupBloc>(create: (_) => sl<InterviewSetupBloc>()),
      ],
      child: MaterialApp(title: 'Flutter Demo', theme: AppTheme.lightTheme, home: const EvaluationPage()),
    );
  }
}
