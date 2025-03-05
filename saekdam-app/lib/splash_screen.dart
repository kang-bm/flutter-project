import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:fly_ai_1/screen/home_screen.dart';
import 'package:fly_ai_1/socket.dart'; // 여기서 전역 소켓 인스턴스(wsService) 사용한다고 가정
import 'package:fly_ai_1/result.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // 초기 상태 텍스트 (예상 소요 시간)
  String statusText = "작업 대기중...";

  @override
  void initState() {
    super.initState();
    // 소켓 채널이 연결되어 있음. -> 메시지 리스닝 시작
    // wsService는 전역 인스턴스로, 연결은 이미 connect()가 호출됨
    wsService.stream.listen(
          (data) async {
        print('Received message: $data');

        try {
          final jsonData = jsonDecode(data);
          final status = jsonData['status'] as String;
          final id = jsonData['taskId'] as String;
          String newText;
          switch (status) {
            case "WAITING":
              newText = "작업 대기중...";
              break;
            case "IN_PROGRESS":
              newText = "작업 진행중...";
              break;
            case "COMPLETED":
              newText = "작업 완료!";
              // COMPLETED 상태일 때 소켓 연결 해제
              wsService.disconnect();

              // 위젯 트리가 완전히 빌드된 후 팝업을 띄우도록 함.
              if (mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false, // 사용자가 외부를 탭해도 닫히지 않음
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text("작업 완료"),
                        content: const Text("결과물을 확인하시겠습니까?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(


                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultScreen(uuid: id),
                                ), // ✅ 홈 화면 이동
                                    (route) => false, // ✅ 이전 화면 모두 제거
                              );
                            },
                            child: const Text("결과물 보기"),
                          ),
                        ],
                      );
                    },
                  );
                });
              }
              break;

            case "FAILED":
              newText = "작업 실패!";
              break;
            default:
              newText = "알 수 없는 상태";
              print('default');
          }
          setState(() {
            statusText = newText;
          });
        } catch (e) {
          print("메시지 파싱 에러: $e");
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed.');
      },
      cancelOnError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // GIF 이미지 표시
          SizedBox(height: screenHeight * 0.4),

          // 이미지 중앙 정렬
          Center(
            child: Image.asset(
              "asset/img/splash_screen_찐최종.gif",
              width: 350,
              height: 350,
              fit: BoxFit.cover,
            ).animate(),
          ),

          // 상태 텍스트 (하단)
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // 버튼 제거 후, 필요하다면 SizedBox 등을 삭제하거나 조정
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
