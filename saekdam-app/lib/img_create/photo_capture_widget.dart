import 'package:flutter/material.dart';
import 'package:fly_ai_1/img_create/prompt_input_screen.dart';
import 'package:fly_ai_1/screen/home_screen.dart';
import 'package:image_picker/image_picker.dart';

class PhotoCaptureWidget extends StatefulWidget {
  const PhotoCaptureWidget({super.key});

  @override
  State<PhotoCaptureWidget> createState() => _PhotoCaptureWidgetState();
}

class _PhotoCaptureWidgetState extends State<PhotoCaptureWidget> {
  final ImagePicker picker = ImagePicker();

  // 이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PromptInputScreen(image: pickedFile),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  // 이미지 소스를 선택하는 다이얼로그 표시 함수
  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("이미지 선택"),
          content: const Text("카메라로 찍으시겠습니까? 아니면 갤러리에서 선택하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                getImage(ImageSource.camera);
              },
              child: const Text("카메라"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                getImage(ImageSource.gallery);
              },
              child: const Text("갤러리"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // 위젯이 완전히 렌더링 된 후 다이얼로그를 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showImageSourceDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
