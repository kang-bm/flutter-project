import 'package:flutter/material.dart';
import 'package:random_number_generator/constant/color.dart';

class SettingScreen extends StatefulWidget {
  final int maxNumber;
  const SettingScreen({
    required this.maxNumber,
    super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double maxNumber =1000;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    maxNumber=widget.maxNumber.toDouble();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Number(
                maxNumber: maxNumber,
              ),
              _Slider(
                value: maxNumber,
                onChanged: (double value){
                  setState(() {
                    maxNumber=value;
                  });
                },
              ),
              _Button(
                onPressed: (){
                  Navigator.of(context).pop(
                    maxNumber.toInt(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.onPressed,
    super.key
  });
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: redColor,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Text("저장!"),);
  }
}
class _Number extends StatelessWidget {
  final double maxNumber;
  const _Number({
    required this.maxNumber,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          child: Row(
            children: maxNumber.toInt().toString().split("")
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
        ));
  }
}

class _Slider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  const _Slider({
    required this.value,
    required this.onChanged,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
        value:value,
        min: 1000,
        max: 100000,
        activeColor: redColor,
        onChanged: onChanged,
    );
  }
}
