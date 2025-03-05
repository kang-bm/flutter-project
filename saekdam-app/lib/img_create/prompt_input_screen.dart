import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fly_ai_1/img_create/prompt_input_dialog.dart';
import 'package:fly_ai_1/img_create/masking.dart'; // ✅ 벽 마스킹 파일 import

// 화면 로딩 시 바로 showDialog를 실행하기 위해 statefulWidget으로 선언
class PromptInputScreen extends StatefulWidget {
  XFile? image;

  PromptInputScreen({this.image, super.key});

  @override
  State<PromptInputScreen> createState() => _PromptInputScreenState();
}

// TODO : 뒤로가기를 누를 시에 대한 작동(HomeScreen으로 돌아가기) 구현하기기
class _PromptInputScreenState extends State<PromptInputScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMaskingSelectDialog(context);
    });
  }

  void _goToMaskingScreen() {
    if (widget.image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MaskingScreen(image: widget.image!),
        ),
      );
    }
  }

  // 마스킹을 할지 말지
  void _showMaskingSelectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("벽 영역을 설정해주세요"),
          content: const Text("자동 선택시 AI가 벽의 위치를 찾아드립니다!"),
          actions: [
            // '네' 선택 시
            // 마스킹 스크린으로 이동
            TextButton(
              onPressed: () {
                _goToMaskingScreen();
              },
              child: const Text("수동"),
            ),
            // '아니오' 선택 시
            // 프롬프트 입력 스크린으로 이동
            TextButton(
              onPressed: () {
                final Map<String, dynamic> maskData = {
                  "x": 0,
                  "y": 0,
                  "width": 1,
                  "height": 1,
                };

                Navigator.pop(context);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return PromptInputDialog(
                      imageFile: widget.image,
                      maskData: maskData,
                    );
                  },
                );
              },
              child: const Text("자동"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: widget.image != null
            ? Image.file(File(widget.image!.path))
            : Text('이미지 없음'),
      ),
    );
  }
}
