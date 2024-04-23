import 'package:flutter/material.dart';
import 'package:news_app/screens/splesh_screen.dart';
import 'package:news_app/utility/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
