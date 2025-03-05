import 'package:flutter/material.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:fly_ai_1/img_create/photo_capture_widget.dart';
import 'dart:async'; // Timer 사용을 위해 필요한 패키지
import 'package:fly_ai_1/screen/gallery.dart';
import 'package:fly_ai_1/screen/community.dart';
import 'package:fly_ai_1/screen/menu.dart';
import 'package:fly_ai_1/api.dart';
import 'package:fly_ai_1/screen/post_preview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  Timer? timer;
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    // 3초마다 자동으로 PageView 넘기는 타이머
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final currentPage = controller.page?.toInt() ?? 0;
      var nextPage = currentPage + 1;

      // 3(4번째 페이지) → 0(첫 번째 페이지) 갈 때는 animateToPage 대신 jumpToPage
      if (nextPage > 3) {
        controller.jumpToPage(0); // 페이지 순간 이동
      } else {
        controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배경색을 연한 회색
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'asset/img/logo_rm.png',
              height: 40,
            ),
            const SizedBox(width: 8),
            // "벽화를 색다르게"
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "벽화를",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: " 색다르게",
                    style: TextStyle(color: pinkmain),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSetting()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------
            // (1) 자동 슬라이드 배너
            // ------------------------------------------------
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 220,
                  child: PageView(
                    controller: controller,
                    children: [1, 2, 3, 4].map(
                      (e) {
                        return Image.asset(
                          'asset/img/paint$e.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),

            // ------------------------------------------------
            // (2) AI 도안(Generate Image) 영역
            // ------------------------------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI 도안',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '맞춤형 디자인을 생성해 보세요!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        // NOTE : 현재는 카메라로만 입력받음
                        // 갤러리에서 사진을 가져오는 기능도 만들까?
                        // 그렇게 정해지면 Modal 하나 더 만들어야겠다
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PhotoCaptureWidget(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pinkmain, // 분홍색
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'AI 벽화 생성',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ------------------------------------------------
            // (3) Community 헤더
            // ------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    '게시판',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Community()),
                      );
                      // Community 전체 보기
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.pinkAccent,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),

            // ------------------------------------------------
            // (4) Community 카드
            // ------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PostPreview(), // <-- 이렇게 바로 삽입
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

      // ------------------------------------------------
      // 하단 네비게이션 바
      // ------------------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: pinkmain,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 1) {
            // 갤러리 아이콘(인덱스 1) 눌렀을 때 GalleryScreen으로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GalleryScreen()),
            );
          }
          if (index == 2) {
            // 갤러리 아이콘(인덱스 1) 눌렀을 때 GalleryScreen으로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Community()),
            );
          }
          // 다른 인덱스별 동작도 필요하면 작성
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈화면',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: '갤러리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: '게시판',
          ),
        ],
      ),
    );
  }
}
