import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/startup/sample.dart';
import 'package:interview_preperation_buddy/app/startup/splash/splash_screens.dart';
import 'package:interview_preperation_buddy/app/themes/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', theme: AppTheme.lightTheme, home: const SamplePage());
  }
}
