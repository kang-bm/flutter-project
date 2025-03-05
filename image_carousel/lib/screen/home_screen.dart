import "package:flutter/material.dart";
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;
  PageController controller = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(
      Duration(seconds: 3),
      (timer) {
        int currentPage = controller.page!.toInt();
        int nextPage = currentPage + 1;
        if (nextPage > 4) {
          nextPage = 0;
        }
        controller.animateToPage(
          nextPage,//넘어갈 페이지
          duration: Duration(milliseconds: 500),//넘어가는 속도
          curve: Curves.linear,//넘어가는 방식
        );
      },
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    if(timer!=null){
      timer!.cancel();
    }
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [1, 2, 3, 4, 5]
            .map(
              (e) => Image.asset(
                'asset/img/image_$e.jpeg',
                fit: BoxFit.cover,
              ),
            )
            .toList(),
      ),
    );
  }
}
//map은 언제 사용하는지(함수와 type)


