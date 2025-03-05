import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.red,
          child: Padding(
            /*padding: EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 64.0,
            ),*/
            padding: EdgeInsets.only(
              top: 32.0,
              left:64,
              right:16,
              bottom:128,
            ),
            child: Container(
              color: Colors.blue,
              width: 50.0,
              height: 50.0,
            ),
          ),
        ),
      ),
    );
  }
}
