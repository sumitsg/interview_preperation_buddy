import 'package:flutter/foundation.dart';
import 'package:interview_preperation_buddy/core/enums/speech_status.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  final SpeechToText _speech = SpeechToText();

  SpeechStatus _status = SpeechStatus.idle;

  bool _initialized = false;

  VoidCallback? _onListeningComplete;
  ValueChanged<String>? _onResultCallback;
  ValueChanged<String>? _onErrorCallback;

  SpeechStatus get status => _status;

  bool get isListening => _speech.isListening;

  Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      _status = SpeechStatus.initializing;

      final available = await _speech.initialize(
        onStatus: _onStatus,
        onError: _onError,
        debugLogging: kDebugMode,
      );

      _initialized = available;

      _status = available ? SpeechStatus.ready : SpeechStatus.unavailable;

      return available;
    } catch (e) {
      _status = SpeechStatus.error;
      debugPrint('Speech initialization failed: $e');
      return false;
    }
  }

  Future<void> startListening({
    required int listenDuration,
    required ValueChanged<String> onResult,
    ValueChanged<String>? onError,
    VoidCallback? onListeningComplete,
  }) async {
    if (_status == SpeechStatus.listening) {
      return;
    }

    final available = await initialize();

    if (!available) {
      onError?.call('Speech recognition unavailable');
      return;
    }

    _onResultCallback = onResult;
    _onErrorCallback = onError;
    _onListeningComplete = onListeningComplete;

    try {
      _status = SpeechStatus.listening;

      await _speech.listen(
        onResult: _onResult,
        listenOptions: SpeechListenOptions(
          listenFor: Duration(seconds: listenDuration),
          pauseFor: const Duration(seconds: 15),
          listenMode: ListenMode.dictation,
          partialResults: true,
          localeId: 'en_US',
          cancelOnError: false,
          autoPunctuation: true,
        ),
      );
    } catch (e) {
      _status = SpeechStatus.error;
      onError?.call(e.toString());
    }
  }

  Future<void> stopListening() async {
    if (_status != SpeechStatus.listening) {
      return;
    }

    try {
      _status = SpeechStatus.stopping;

      await _speech.stop();

      _status = SpeechStatus.ready;
    } catch (e) {
      _status = SpeechStatus.error;
      debugPrint('Stop listening failed: $e');
    }
  }

  Future<void> cancelListening() async {
    try {
      await _speech.cancel();
      _status = SpeechStatus.ready;
    } catch (e) {
      debugPrint('Cancel listening failed: $e');
    }
  }

  void _onResult(SpeechRecognitionResult result) {
    _onResultCallback?.call(result.recognizedWords);
  }

  void _onError(SpeechRecognitionError error) {
    debugPrint(
      'Speech Error: ${error.errorMsg} '
      '(permanent: ${error.permanent})',
    );

    _status = SpeechStatus.error;

    _onErrorCallback?.call(error.errorMsg);
  }

  void _onStatus(String status) {
    debugPrint('Speech Status: $status');

    switch (status.toLowerCase()) {
      case 'listening':
        _status = SpeechStatus.listening;
        break;

      case 'notlistening':
      case 'done':
        if (_status == SpeechStatus.listening ||
            _status == SpeechStatus.stopping) {
          _status = SpeechStatus.ready;
          _onListeningComplete?.call();
        }
        break;
    }
  }

  Future<List<LocaleName>> locales() async {
    if (!_initialized) {
      await initialize();
    }

    return _speech.locales();
  }

  Future<LocaleName?> systemLocale() async {
    if (!_initialized) {
      await initialize();
    }

    return _speech.systemLocale();
  }
}
