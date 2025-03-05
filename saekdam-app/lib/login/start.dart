import 'package:flutter/material.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:fly_ai_1/login/loginpage.dart';
import 'package:fly_ai_1/screen/home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  String _userError = "";
  String _emailError = '';
  String _passwordError = '';
  String _confirmError = '';

  bool _isSignUpEnabled = false; // 가입완료 버튼 활성화 상태

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // 이름 검증
  void _validateUser(String value) {
    if (value.length < 2) {
      setState(() {
        _userError = '유저이름은 2글자 이상이어야 합니다.';
      });
    }
    else if(value.length>5){
      setState(() {
        _userError = '유저이름은 5글자 이하여야 합니다.';
      });
    }
    else {
      setState(() {
        _userError = '';
      });
    }
    _checkFormValidity();
  }
  // 이메일 검증
  void _validateEmail(String value) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (value.length < 5) {
      setState(() {
        _emailError = '이메일은 5글자 이상이어야 합니다.';
      });
    } else if (value.length > 50) {
      setState(() {
        _emailError = '이메일은 50글자 이하여야 합니다.';
      });
    } else if (!emailRegex.hasMatch(value)) {
      setState(() {
        _emailError = '이메일 형식이 아닙니다.';
      });
    } else {
      setState(() {
        _emailError = '';
      });
    }
    _checkFormValidity();
  }

  // 비밀번호 검증
  void _validatePassword(String value) {
    if (value.length < 8) {
      setState(() {
        _passwordError = '비밀번호는 8글자 이상이어야 합니다.';
      });
    }
    else if(value.length>30){
      setState(() {
        _passwordError = '비밀번호는 30글자 이하여야 합니다.';
      });
    }
    else {
      setState(() {
        _passwordError = '';
      });
    }
    _checkFormValidity();
  }

  // 비밀번호 확인 검증
  void _validateConfirm(String value) {
    if (value != _passController.text) {
      setState(() {
        _confirmError = '비밀번호가 일치하지 않습니다.';
      });
    } else {
      setState(() {
        _confirmError = '';
      });
    }
    _checkFormValidity();
  }

  // 폼 유효성 확인
  void _checkFormValidity() {
    final isFormValid = _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _emailError.isEmpty &&
        _passController.text.isNotEmpty &&
        _passwordError.isEmpty &&
        _confirmController.text.isNotEmpty &&
        _confirmError.isEmpty;

    setState(() {
      _isSignUpEnabled = isFormValid; // 모든 조건을 만족하면 활성화
    });
  }

  // 가입 완료 버튼 클릭 시
  Future<void> _onSignUp() async {
    // 이미 _isSignUpEnabled로 폼 검증이 되어 있으니, 추가로 체크해도 좋습니다
    if (!_isSignUpEnabled) return;

    // 1) 입력값 정리
    final username = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passController.text.trim();

    // 로딩 스피너를 쓰고 싶다면
    // setState(() { _isLoading = true; });

    try {
      // 2) 서버에 회원가입 요청
      final uri = Uri.parse('https://saekdam.kro.kr/api/users');  // 실제 서버 URL
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      // 3) 응답 처리
      if (response.statusCode == 200 || response.statusCode == 201) {
        // 성공 시, 서버에서 JSON으로 회원정보( id, email, ... )가 온다고 했으므로 파싱
        final decoded = jsonDecode(utf8.decode(response.bodyBytes))
        as Map<String, dynamic>;

        // 예: 가입 완료 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 성공!  환영합니다, ${decoded['username']} 님')),
        );

        // 4) 가입 성공 후 원하는 화면으로 이동(로그인 페이지로 이동 예시)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // 실패 시, {message, code, timestamp} 등 JSON 형태일 것이라 가정
        final decoded = jsonDecode(utf8.decode(response.bodyBytes))
        as Map<String, dynamic>;
        final errorMessage = decoded['message'] ?? '회원가입 실패';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    } finally {
      // setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 11),

              // 부제목
              Row(
                children: [
                  const Text(
                    '벽화를 ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '색다르게',
                    style: TextStyle(
                      fontSize: 16,
                      color: pinkmain,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // (1) 이름 입력
              TextField(
                controller: _nameController,
                onChanged: _validateUser,
                decoration: InputDecoration(
                  labelText: '이름',
                  hintText: "이름을 입력하세요",
                  border: OutlineInputBorder(),
                  errorText: _userError.isNotEmpty ? _userError : null,
                ),
              ),
              const SizedBox(height: 20),

              // (2) 이메일 입력
              TextField(
                controller: _emailController,
                onChanged: _validateEmail,
                decoration: InputDecoration(
                  labelText: '이메일',
                  hintText: "이메일을 입력하세요",
                  border: OutlineInputBorder(),
                  errorText: _emailError.isNotEmpty ? _emailError : null,
                ),
              ),
              const SizedBox(height: 20),

              // (3) 비밀번호 입력
              TextField(
                controller: _passController,
                onChanged: _validatePassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: "비밀번호를 입력하세요",
                  border: OutlineInputBorder(),
                  errorText: _passwordError.isNotEmpty ? _passwordError : null,
                ),
              ),
              const SizedBox(height: 20),

              // (4) 비밀번호 확인
              TextField(
                controller: _confirmController,
                onChanged: _validateConfirm,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  hintText: "비밀번호를 입력하세요",
                  border: OutlineInputBorder(),
                  errorText: _confirmError.isNotEmpty ? _confirmError : null,
                ),
              ),
              const Spacer(),

              // (5) 가입완료 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pinkmain,
                    disabledBackgroundColor: Color(0xFFffcce4), // 조건에 따라 색상 변경
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isSignUpEnabled ? _onSignUp : null, // 조건에 따라 활성화/비활성화
                  child: const Text(
                    '가입완료',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
