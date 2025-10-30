import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const Dot2DotApp());
}

class Dot2DotApp extends StatelessWidget {
  const Dot2DotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dot2Dot - 인간관계 성향 분석',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.light,
          primary: Colors.grey[900]!,
          secondary: Colors.grey[700]!,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        fontFamily: 'NotoSans',
      ),
      home: const HomeScreen(),
    );
  }
}