import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}

///stless를 이용해서 StatelessWidget class 쉽게 생성
/// StatelessWidget
/// 여러개 위젯 하나로 묶기

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///rgb색 335CB0 #36c794
      backgroundColor: Color(0xFF335CB0), //0xFF뒤에 rgb값 붙이기
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 32.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //children은 여러개 위젯을 받음
            Image.asset(
              'asset/img/logo.png',//이미지 가져오기
            ),
            SizedBox(height: 28.0,),
            CircularProgressIndicator(
              color: Colors.white,
            ), //돌아가는 로딩창
          ],
        ),
      ),
    );
  }
}
