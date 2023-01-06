import 'dart:io';

import 'package:chat_gpt_demo/src/services/tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/utils/colors.dart';
import 'src/utils/strings.dart';
import 'src/view/home/home_screen.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  TextToSpeech.initTTS();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      title: appName,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: appColor,
            foregroundColor: kWhite,
          )
      ),
    );
  }
}
