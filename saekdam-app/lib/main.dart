import 'package:flutter/material.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:fly_ai_1/img_create/photo_capture_widget.dart';
import 'package:fly_ai_1/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fly_ai_1/login/welcome.dart';
import 'package:fly_ai_1/screen/community.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('loggedIn') ?? false;


  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // TextField 전역 스타일
        inputDecorationTheme: InputDecorationTheme(
          // 비포커스 라벨
          labelStyle: TextStyle(color: greysub),
          // 포커스 시(라벨이 떠오르는 상태) 라벨
          floatingLabelStyle: TextStyle(color: greymain),
          // 비포커스 테두리 (연한 색)
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: greysub,
              width: 2.5,
            ),
          ),

          // 포커스 테두리 (어두운 색)
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: greymain,
              width: 2.5,
            ),
          ),
        ),
        // 텍스트 선택(드래그) 시 하이라이트/커서 색상도 바꿀 경우
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFffb2d7),
          selectionColor: Color(0xFFffb2d7), // 드래그 영역
          selectionHandleColor: Color(0xFFffb2d7),
        ),
      ),
      // 이미 로그인 상태면 HomeScreen 바로 보여주고,
      // 아니면 WelcomeScreen 먼저 보여줌
      home: isLoggedIn ? const HomeScreen() : WelcomeScreen(),
      // home: HomeScreen(),
      // 필요 시 라우트 등록
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}