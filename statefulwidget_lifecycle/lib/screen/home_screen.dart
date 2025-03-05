import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool show = false;
  Color color= Colors.red;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (show) GestureDetector(
              onTap: (){
                setState(() {
                  color = color == Colors.blue ? Colors.red :Colors.blue;
                });
              },
              child: CodeFactoryWidget(
                color: color,
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  show= !show;
                });
              },
              child: Text("클릭 보이기/안보이기"),
            )
            //리스트 안에서 사용할 수 있는 문법
          ],
        ),
      ),
    );
  }
}

class CodeFactoryWidget extends StatefulWidget {
  final Color color;
  CodeFactoryWidget({
    required this.color,
    super.key,}){
    print("1) stateful widget constructor");
  }

  @override
  State<CodeFactoryWidget> createState(){
    print("2) stateful widget create state");
    return _CodeFactoryWidgetState();
  }
}

class _CodeFactoryWidgetState extends State<CodeFactoryWidget> {
  @override
  void initState() {
    print("3) stateful widget initstate");
    super.initState();
  }
  @override
  void didChangeDependencies() {
    print("4) stateful widget didchangedependencies");
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    print("5) stateful widget build");
    return Container(
      color: widget.color,
      width: 50.0,
      height: 50.0,
    );
  }
  @override
  void deactivate() {
    print("6) stateful widget deactivate");
    super.deactivate();
  }
  @override
  void dispose() {
    print("7) stateful widget dispose");
    super.dispose();
  }
}
