import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognition {
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<String> recognizeSpeech() async {
    Completer<String> completer = Completer<String>();

    bool available = await _speech.initialize(
      onStatus: (status) {
        print('onStatus: $status');
      },
      onError: (error) {
        print('onError: $error');
        completer.completeError(error);
      },
    );

    if (available) {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            completer.complete(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 100),
        pauseFor: const Duration(seconds: 10),
        cancelOnError: true,
      );
    }

    return completer.future;
  }

  void cancelRecognition() {
    _speech.cancel();
  }
}