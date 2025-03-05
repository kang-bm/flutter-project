import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _moved = false;

  // TODO
  // 무한 루프로 만들어야함
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOut,
                left: _moved ? -1200 : 0,
                top: _moved ? -50 : 150,
                child: Opacity(
                  opacity: 0.8,
                  child: Image.asset(
                    'asset/img/wave_mint.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOut,
                left: _moved ? 0 : -1200,
                top: _moved ? -50 : 200,
                child: Opacity(
                  opacity: 1,
                  child: Image.asset(
                    'asset/img/wave_pink.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Image.asset(
                'asset/img/droplet.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _moved = !_moved;
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
