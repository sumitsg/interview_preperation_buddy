import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:interview_preperation_buddy/core/services/bloc_observer.dart';

import 'app/di/injection_container.dart';
import 'app/startup/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bloc.observer = AppBlocObserver();
  await dotenv.load(fileName: ".env");
  await init(); // IMPORTANT
  runApp(const MyApp());
}
