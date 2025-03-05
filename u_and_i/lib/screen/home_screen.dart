import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//google font에서 font다운 가능
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate= DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100], //500기준??
      body: SafeArea(
        top: true,
        bottom: false,
        child: SizedBox(
          //크기 정하는 위젯
          width: MediaQuery.of(context).size.width, //최대너비로 설정
          child: Column(
            children: [
              _Top(
                selectedDate: selectedDate,
                onPressed: onHeartPressed,
              ), //글자
              _Bottom(), //이미지
            ],
          ),
        ),
      ),
    );
  }
  onHeartPressed(){
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white,
            height: 300.0,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,//날짜만 사용
              initialDateTime: selectedDate,
              maximumDate: DateTime.now(),
              onDateTimeChanged: (DateTime date) {
                setState((){
                  selectedDate=date;
                });
              },
              dateOrder: DatePickerDateOrder.ymd,
            ),
          ),
        );
      },
    );
  }
}

class _Top extends StatelessWidget {
  //_ 넣은 이유는 내부에서만 쓸수 있게 하기위해서
  final DateTime selectedDate;
  final VoidCallback? onPressed;
  const _Top({
    required this.selectedDate,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final now= DateTime.now();
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Text(
              "U&I",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              "우리 처음 만난 날",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${selectedDate.year}.${selectedDate.month}.${selectedDate.day}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            IconButton(
              iconSize: 60,
              color: Colors.red[400],
              onPressed: onPressed,
              icon: Icon(Icons.favorite),
            ),
            Text(
              "D+${now.difference(selectedDate).inDays+1}",
              style: Theme.of(context).textTheme.displayMedium,
            )
          ],
        ),
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Image.asset('asset/img/middle_image.png'),
      ),
    );
  }
}



