import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/di/injection_container.dart';
import 'app/startup/app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await init(); // IMPORTANT
  runApp(const MyApp());
}
