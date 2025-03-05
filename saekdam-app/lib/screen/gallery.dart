import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fly_ai_1/api.dart'; // API 파일 import
import 'package:fly_ai_1/screen/imagepreview.dart'; // API 파일 import

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ImagePicker _picker = ImagePicker();
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages(); // 앱 실행 시 저장된 이미지와 asset 이미지 불러오기
  }

  // 저장된 이미지와 asset 이미지를 한 번에 불러오기
  Future<void> _loadImages() async {
    List<String> savedImages = await loadImagesFromLocalStorage();
    List<String> assetImages = [
      "asset/img/paint1.jpg",
      "asset/img/paint2.jpg",
      "asset/img/paint3.jpg",
      "asset/img/paint4.jpg",
    ];

    setState(() {
      // asset 이미지가 앞쪽에 오도록 합침
      _images = [...assetImages, ...savedImages];
    });
    print("✅ 최종 이미지 리스트: $_images");

  }

  // 갤러리에서 이미지 선택 후 내부 저장소에 저장
  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String savedPath =
      await saveImageToLocalDirectory(File(pickedFile.path));
      setState(() {
        _images.add(savedPath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: null,
          centerTitle: false,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 15),
                child: Row(
                  children: [
                    Image.asset(
                      'asset/img/logo_rm.png',
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      ':Gallery',
                      style: TextStyle(
                        fontFamily: 'sunflower',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        // 모든 이미지를 표시하도록 itemCount를 _images.length로 설정
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ImagePreviewScreen(
                        images: _images, // 🔥 전체 이미지 리스트 넘김
                        initialIndex: index, // 클릭한 이미지의 인덱스를 넘김
                      ),
                ),
              );
            },
            child: _images[index].startsWith('asset')
                ? Image.asset(_images[index], fit: BoxFit.cover)
                : Image.file(File(_images[index]), fit: BoxFit.cover),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
// 이미지 미리보기 화면
