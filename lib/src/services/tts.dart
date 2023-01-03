import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech{
  static FlutterTts tts= FlutterTts();

  static initTTS()async{
    print(await tts.getLanguages);
    tts.setLanguage("en-US");
    // tts.setPitch(1.0);
    // tts.setSpeechRate(1.0);
    // tts.setVolume(1.0);
  }

  static speak(String? msg)async{
    tts.setStartHandler(() {
      print('TTS is started!');
    });
    tts.setCompletionHandler(() {
      print('TTS is completed!');
    });
    tts.setErrorHandler((message) {
      print(message);
    });

    await tts.awaitSpeakCompletion(true);
    tts.speak(msg ?? '');
  }
}