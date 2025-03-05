import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("GIF 애니메이션 조절 예제")),
        body: Center(
          child: Image.asset("asset/splash_screen_gif.gif")
              .animate()
              .fade(duration: 500.ms) // 0.5초 동안 페이드 인
              .scale(delay: 500.ms, duration: 1.seconds), // 크기 확대 효과
        ),
      ),
    );
  }
}
