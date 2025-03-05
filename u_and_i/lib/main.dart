import 'package:flutter/material.dart';
import 'package:u_and_i/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(//앱 전체 폰트와 텍스트 관리
      fontFamily: 'sunflower',//기본 폰트
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 80.0,
          fontFamily: "parisienne",
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize:50,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        )
      )
    ),
    home: HomeScreen(),
  ));
}

