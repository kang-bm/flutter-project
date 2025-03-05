import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:fly_ai_1/login/loginpage.dart';
import 'package:fly_ai_1/setting/profile_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  String nickname = "익명"; // 기본 닉네임
  File? profileImage; // 사용자가 선택한 프로필 이미지

  @override
  void initState() {
    super.initState();
    _fetchUserInfo(); // 🔹 사용자 정보 불러오기
  }

  /// 🔹 서버에서 사용자 정보 가져와 닉네임 설정
  Future<void> _fetchUserInfo() async {
    try {
      // 1) SharedPreferences에서 JWT 토큰 가져오기
      final prefs = await SharedPreferences.getInstance();
      final jwt = prefs.getString('jwt_token');
      if (jwt == null) {
        // 로그인 안 되어 있으니 기본 닉네임 유지 or 로그인 페이지 유도
        print('JWT가 없습니다. 로그인 필요.');
        return;
      }

      // 2) 서버에 사용자 정보 요청 (예: GET /api/users/me)
      final uri = Uri.parse('https://saekdam.kro.kr/api/users/me'); // 실제 API URL
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt', // JWT 토큰 삽입
        },
      );

      if (response.statusCode == 200) {
        // 성공 시 JSON 파싱
        final decoded = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

        // 예: 서버가 { "username": "사용자닉네임", ... } 형태로 준다고 가정
        final serverNickname = decoded['username'] ?? '익명';

        // setState로 닉네임 반영
        setState(() {
          nickname = serverNickname;
        });

        // 혹시 프로필 이미지 URL도 서버에서 준다면 profileImage도 여기서 처리
        // final profileImageUrl = decoded['profileImageUrl'];
        // ...

      } else {
        print('사용자 정보 조회 실패: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('사용자 정보 조회 중 에러: $e');
    }
  }

  /// 🔹 프로필 수정 화면으로 이동 & 결과 받아오기
  Future<void> _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(
          initialName: nickname,
          initialProfileImage: profileImage,
        ),
      ),
    );

    // 사용자가 수정한 닉네임과 프로필 사진을 적용
    if (result != null) {
      setState(() {
        nickname = result['name'] ?? nickname;
        profileImage = result['profileImage'] ?? profileImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "내 프로필",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                /// 프로필 이미지
                SizedBox(
                  width: 120, // 원 크기
                  height: 120,
                  child: ClipOval(
                    child: SvgPicture.network(
                      'https://api.dicebear.com/9.x/thumbs/svg?seed=${nickname.isNotEmpty ? nickname : '익명'}',
                      placeholderBuilder: (context) => CircularProgressIndicator(), // 로딩 중 표시
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// 닉네임 표시
                Text(nickname,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                /// 프로필 수정 버튼
                TextButton(
                  onPressed: _editProfile,
                  child: Text("프로필 수정", style: TextStyle(color: pinkmain)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Divider(),
          ),

          /// 계정 설정 섹션
          _buildSectionTitle("계정"),
          _buildListTile("이메일 변경", EmailChangeScreen()),
          _buildListTile("비밀번호 변경", PasswordChangeScreen()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Divider(),
          ),

          /// 이용 안내 섹션
          _buildSectionTitle("이용 안내"),
          _buildListTile("앱 버전", null, trailing: const Text("1.0.1")),
          _buildListTile("문의하기", InquiryScreen()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Divider(),
          ),

          /// 기타 설정 섹션
          _buildSectionTitle("기타"),
          _buildListTile("회원 탈퇴", WithdrawalScreen()),

          /// 로그아웃
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListTile(
              title: const Text("로그아웃"),
              onTap: () async {
                // ✅ 1. SharedPreferences 인스턴스 가져오기
                final prefs = await SharedPreferences.getInstance();

                // ✅ 2. 저장된 JWT 토큰 삭제
                await prefs.remove('jwt_token'); // 저장된 로그인 정보 삭제
                await prefs.remove('user_info'); // 혹시 저장된 추가 사용자 정보도 삭제

                // ✅ 3. 모든 이전 화면 제거 후 로그인 페이지로 이동
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                    settings: const RouteSettings(arguments: true),
                  ),
                      (Route<dynamic> route) => false, // 모든 이전 화면 삭제
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 섹션 제목
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  /// 설정 항목 리스트
  Widget _buildListTile(String title, Widget? targetScreen, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        title: Text(title),
        trailing: trailing,
        onTap: targetScreen != null
            ? () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
        }
            : null,
      ),
    );
  }
}

/// 이메일 변경 페이지
class EmailChangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("이메일 변경")
        ));
  }
}

/// 비밀번호 변경 페이지
class PasswordChangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("비밀번호 변경")
        ));
  }
}

/// 문의하기 페이지
class InquiryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("문의하기")
        ));
  }
}

/// 회원 탈퇴 페이지
class WithdrawalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("회원 탈퇴")
        ));
  }
}
