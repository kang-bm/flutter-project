import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fly_ai_1/img_create/photo_capture_widget.dart';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'package:fly_ai_1/screen/home_screen.dart';

class ResultScreen extends StatefulWidget {
  final String uuid;

  const ResultScreen({Key? key, required this.uuid}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Future<Uint8List> imageFuture;

  @override
  void initState() {
    super.initState();
    // initState는 동기 함수이므로, 별도 async 함수를 호출하여 비동기 작업을 처리합니다.
    imageFuture = _loadImageBytes();
  }

  // _loadImage는 presigned URL을 통해 이미지 파일을 다운로드합니다.
  Future<File?> _loadImage() async {
    // 함수 A: uuid를 이용해 presigned URL 가져오기 (구현된 ApiService.GET_imgurl)
    final presignedUrl = await ApiService.GET_imgurl(widget.uuid);
    // 함수 B: presigned URL로부터 이미지 다운로드 (구현된 ApiService.downloadImageFromPresignedUrl)
    File? imageData = await ApiService.downloadImageFromPresignedUrl(presignedUrl);
    return imageData;
  }

  // _loadImageBytes는 _loadImage에서 받은 파일의 바이트 데이터를 읽어 Future<Uint8List>를 반환합니다.
  Future<Uint8List> _loadImageBytes() async {
    File? file = await _loadImage();
    if (file == null) {
      throw Exception("Image file is null");
    }
    return await file.readAsBytes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Uint8List>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return Stack(
              children: [
                // Positioned를 이용해 이미지의 위치를 조절
                Positioned(
                  top: -10, // 상단에서 20픽셀 떨어진 위치 (원하는 값으로 조절)
                  left: 0,
                  right: 0,
                  bottom: 120, // 버튼 영역과 겹치지 않도록 여유를 둠 (원하는 값으로 조절)

                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.contain,
                  ),
                ),
                // 버튼 Row를 이미지 위에, 화면 하단에서 50px 위에 배치
                Positioned(
                  bottom: 75,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 3,
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoCaptureWidget(),
                              ),
                                  (route) => false,
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("다시하기"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 3,
                          ),
                          onPressed: () async {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                                  (route) => false,
                            );
                          },
                          icon: const Icon(Icons.home),
                          label: const Text("홈으로 이동"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("No image data available."));
          }
        },
      ),
    );
  }


}