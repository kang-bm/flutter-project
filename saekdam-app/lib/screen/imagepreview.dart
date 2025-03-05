import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImagePreviewScreen({Key? key, required this.images, required this.initialIndex})
      : super(key: key);

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  late PageController _pageController;
  int currentIndex = 0;
  bool isZooming = false; // 🔥 확대 상태 체크
  TransformationController _transformationController = TransformationController();
  Offset _startingFocalPoint = Offset.zero;
  Offset _translation = Offset.zero;
  bool _isDragging = false; // 🔥 드래그 중인지 체크

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;
  }

  /// 🔥 현재 확대 상태를 확인하는 함수 (확대값이 원래 크기와 거의 같으면 false)
  bool _isZoomedIn() {
    final matrix = _transformationController.value;
    return matrix.getMaxScaleOnAxis() > 1.05; // 1.05 이상이면 확대된 것으로 판단
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 🔥 배경을 흰색으로 변경
      appBar: AppBar(
        backgroundColor: Colors.white, // 앱바도 흰색으로 변경
        iconTheme: IconThemeData(color: Colors.black), // 뒤로가기 버튼 색상 변경
        elevation: 0, // 앱바 그림자 제거
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: isZooming ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(), // 🔥 확대 중엔 스와이프 비활성화
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Center(
            child: GestureDetector(
              onDoubleTap: () {
                setState(() {
                  if (_isZoomedIn()) {
                    _transformationController.value = Matrix4.identity();
                    isZooming = false; // 🔥 확대 해제되면 스와이프 가능하도록 설정
                  } else {
                    _transformationController.value = Matrix4.identity()..scale(2.5); // 🔥 두 번 탭하면 2.5배 확대
                    isZooming = true;
                  }
                });
              },
              onScaleStart: (details) {
                _startingFocalPoint = details.focalPoint;
                _isDragging = false;
              },
              onScaleUpdate: (details) {
                if (_isZoomedIn()) {
                  setState(() {
                    _isDragging = true; // 🔥 확대된 상태에서만 드래그 가능
                    _translation = details.focalPoint - _startingFocalPoint;
                  });
                }
              },
              onScaleEnd: (details) {
                setState(() {
                  isZooming = _isZoomedIn(); // 🔥 확대 상태를 더 정확히 감지
                  _isDragging = false; // 드래그 종료
                });
              },
              child: InteractiveViewer(
                transformationController: _transformationController,
                panEnabled: _isDragging, // 🔥 확대 중일 때만 드래그 활성화
                boundaryMargin: EdgeInsets.zero, // 🔥 확대 시 경계 없이 자연스럽게 화면 채우도록 설정
                minScale: 1.0, // 기본 크기
                maxScale: 4.0, // 최대 확대 크기
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: widget.images[index].startsWith('asset')
                      ? Image.asset(widget.images[index], fit: BoxFit.contain)
                      : Image.file(File(widget.images[index]), fit: BoxFit.contain),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
