import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get GEMINIAPIKEY => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get GEMINIMODEL => dotenv.env['GEMINI_MODEL'] ?? '';
}
