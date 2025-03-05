import 'package:flutter/material.dart';
import 'package:row_and_column/const/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, //초기값 center
              children: colors
                  .map(
                    (e) => Container(
                  height: 50.0,
                  width: 50.0,
                  color: e,
                ),
              )
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  color:Colors.orange,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, //초기값 center
              children: colors
                  .map(
                    (e) => Container(
                  height: 50.0,
                  width: 50.0,
                  color: e,
                ),
              )
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  color:Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
//언제 ,고 언제 ;인지
//Expanded()위젯: 나머지 공간 다 차지,Expanded가 여러개일경우 Expanded끼리 나머지 공간 나눠 가짐(+flex는 나머지 공간을 나눠 가지는 비율 정해줌)
