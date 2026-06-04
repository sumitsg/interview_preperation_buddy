import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/app/startup/splash/splash_screens.dart';

import '../../feature/interview/bloc/interview_bloc.dart';
import '../../feature/interview/ui/interview_setup_page.dart';
import '../di/injection_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InterviewBloc>(
          create: (_) => sl<InterviewBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const InterviewSetupPage(),
      ),
    );
  }
}
