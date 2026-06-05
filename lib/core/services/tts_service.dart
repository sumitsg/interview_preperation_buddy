import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:interview_preperation_buddy/core/enums/tts_state.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  bool _initialized = false;

  TtsStatus _status = TtsStatus.initial;

  VoidCallback? _onCompleted;
  ValueChanged<String>? _onError;

  TtsStatus get status => _status;

  bool get isSpeaking => _status == TtsStatus.speaking;

  Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      _status = TtsStatus.initializing;

      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.40);
      await _tts.setVolume(1.0);
      await _tts.setPitch(0.85);

      _tts.setStartHandler(() {
        _status = TtsStatus.speaking;
      });

      _tts.setCompletionHandler(() {
        _status = TtsStatus.ready;
        _onCompleted?.call();
      });

      _tts.setCancelHandler(() {
        _status = TtsStatus.ready;
      });

      _tts.setErrorHandler((message) {
        _status = TtsStatus.error;
        print('TTS Error: $message');
        _onError?.call(message);
      });

      _initialized = true;
      _status = TtsStatus.ready;

      return true;
    } catch (e) {
      _status = TtsStatus.error;
      debugPrint('TTS Init Error: $e');
      return false;
    }
  }

  Future<void> speak({required String text, VoidCallback? onCompleted, ValueChanged<String>? onError}) async {
    if (text.trim().isEmpty) {
      return;
    }

    final available = await initialize();

    if (!available) {
      onError?.call('TTS unavailable');
      return;
    }

    _onCompleted = onCompleted;
    _onError = onError;

    if (_status == TtsStatus.speaking) {
      await stop();
    }

    try {
      _status = TtsStatus.speaking;

      await _tts.speak(text);
    } catch (e) {
      _status = TtsStatus.error;
      onError?.call(e.toString());
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();

      _status = TtsStatus.stopped;
    } catch (e) {
      debugPrint('TTS Stop Error: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _tts.pause();
    } catch (e) {
      debugPrint('TTS Pause Error: $e');
    }
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}
