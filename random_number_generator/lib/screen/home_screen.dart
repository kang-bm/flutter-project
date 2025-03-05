import 'package:flutter/material.dart';
import 'package:random_number_generator/constant/color.dart';
import 'dart:math';
import 'package:random_number_generator/screen/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> numbers = [
    123,
    456,
    789,
  ];
  int maxNumber=1000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              ///제목과 아이콘 버튼
              _Header(
                onPressed: onSettingIconPressed,
              ),

              /// 숫자가 있는 곳
              _Body(
                numbers: numbers,
              ),

              /// 버튼이 있는곳
              _Footer(
                onPressed: generateRandomNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSettingIconPressed() async{
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:(BuildContext context){
          return SettingScreen(
            maxNumber: maxNumber,
          );
        },),
    );//화면을 넣음
    maxNumber=result;
  }

  generateRandomNumber() {
    final rand = Random();
    final Set<int> newNumbers = {}; //중복되는 값 제거
    while (newNumbers.length < 3) {
      final randomNumber = rand.nextInt(maxNumber);
      newNumbers.add(randomNumber);
    }

    setState(() {
      numbers = newNumbers.toList();
    });
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onPressed;

  const _Header({
    required this.onPressed,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "랜덤숫자 생성기",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.w700, //좀더 두꺼운 글시체
          ),
        ),
        IconButton(
            color: redColor,
            onPressed: onPressed,
            icon: Icon(
              Icons.settings,
            ))
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final List<int> numbers;

  const _Body({
    required this.numbers,
    super.key,});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        numbers.map((e) => e.toString().split(""))
            .map(
              (e) =>
              Row(
                children: e
                    .map(
                      (number) =>
                      Image.asset(
                        "asset/img/$number.png",
                        width: 50.0,
                        height: 70.0,
                      ),
                )
                    .toList(),
              ),
        )
            .toList(),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressed;

  const _Footer({
    required this.onPressed,
    super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: redColor,
          foregroundColor: Colors.white,
        ),
        child: Text("생성하기!"));
  }
}
