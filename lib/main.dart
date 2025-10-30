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
        primarySwatch: Colors.blue,
        fontFamily: 'NotoSans',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4CE6),
          brightness: Brightness.light,
        ),
      ),
      home: HomeScreen(),
    );
  }
}