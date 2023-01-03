import 'package:chat_gpt_demo/src/utils/colors.dart';
import 'package:chat_gpt_demo/src/utils/strings.dart';
import 'package:flutter/material.dart';

import 'src/view/home/home_screen.dart';

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
