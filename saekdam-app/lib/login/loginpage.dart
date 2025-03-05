import 'package:flutter/material.dart';
import 'package:fly_ai_1/login/start.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:fly_ai_1/screen/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';                         // JSON encode/decode
import 'package:http/http.dart' as http;       // http 요청
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginButtonEnabled = false;

  /// 로딩 상태 플래그 (두 번째 코드 참고)
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 폼 검증
  void _validateForm() {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      setState(() {
        _isLoginButtonEnabled = true;
      });
    } else {
      setState(() {
        _isLoginButtonEnabled = false;
      });
    }
  }

  /// 기존 ID/PW 로그인 예시
  Future<void> _onLoginPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true; // 로딩 시작
    });

    try {
      // 1) 서버로 로그인 요청
      final uri = Uri.parse('https://saekdam.kro.kr/api/users/login'); // 실제 서버 주소
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // 2) 응답 결과 확인
      if (response.statusCode == 200) {
        // 서버에서 JWT 문자열만 반환된다고 가정
        final jwt = response.body;

        // 3) shared_preferences에 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', jwt);

        // 4) 로그인 성공 안내
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 성공!')),
        );

        // 5) 홈 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // 실패 시에는 {message, code, timestamp} 구조의 JSON이 온다고 가정
        final decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> errorData = jsonDecode(decodedBody);
        final errorMessage = errorData['message'] ?? '로그인 실패';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('에러가 발생했습니다: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // 로딩 해제
      });
    }
  }

  /// 두 번째 코드에서 가져온 구글 로그인 로직


  ///kakao 로그인
  Future<void> _loginKakao() async {
    setState(() => _isLoading = true);
    try {
      // 1) 서버에서 Kakao LoginUrl 가져오기
      final loginUrl = await _fetchKakaoLoginUrl();
      if (loginUrl == null) {
        throw Exception("카카오 로그인 URL을 가져오지 못했습니다.");
      }

      // 2) 웹뷰 화면으로 이동 + 결과 받기
      final loginResult = await Navigator.push<String?>(
        context,
        MaterialPageRoute(builder: (_) => KakaoWebViewPage(loginUrl: loginUrl)),
      );

      // 3) 웹뷰 닫힌 뒤, 결과가 'SUCCESS'라면 HomeScreen으로 이동
      if (loginResult == 'SUCCESS') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('카카오 로그인 성공!')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카카오 로그인 에러: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 서버에서 loginUrl을 가져오는 함수
  Future<String?> _fetchKakaoLoginUrl() async {
    try {
      final uri = Uri.parse('https://saekdam.kro.kr/api/auth/kakao/login');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return decoded['loginUrl'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('fetchKakaoLoginUrl error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool fromLogout = ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: (ModalRoute.of(context)?.settings.arguments as bool? ?? false)
            ? null // 🔹 로그아웃을 통해 들어왔으면 뒤로가기 버튼 제거
            : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                    const SizedBox(height: 4),
                    const Text(
                      "맞춤형 디자인을 생성해 보세요!",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "이메일",
                        hintText: "이메일을 입력하세요",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "비밀번호",
                        hintText: "비밀번호를 입력하세요",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pinkmain,
                          disabledBackgroundColor: Color(0xFFffcce4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoginButtonEnabled ? _onLoginPressed : null,
                        child: const Text(
                          '로그인',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StartPage()),
                            );
                          },
                          child: const Text("회원가입"),
                        ),
                        Container(height: 15, child: const VerticalDivider(color: greymain)),
                        TextButton(
                          onPressed: () {
                            // 비밀번호 찾기
                          },
                          child: const Text("비밀번호 찾기"),
                        ),
                        Container(height: 15, child: const VerticalDivider(color: greymain)),
                        TextButton(
                          onPressed: () {
                            // 비회원 로그인
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          },
                          child: const Text("비회원 로그인"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //kakao
                        IconButton(
                          icon: SvgPicture.asset(
                            'asset/img/btn_kakao.svg',
                            width: 50,
                            height: 50,
                          ),
                          onPressed: _loginKakao,
                        ),
                        // Google

                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 로딩 인디케이터 (원하시면 추가)
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class KakaoWebViewPage extends StatefulWidget {
  final String loginUrl;
  const KakaoWebViewPage({Key? key, required this.loginUrl}) : super(key: key);

  @override
  State<KakaoWebViewPage> createState() => _KakaoWebViewPageState();
}

class _KakaoWebViewPageState extends State<KakaoWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (navReq) {
            final url = navReq.url;
            // 리다이렉트 감지
            if (url.startsWith('https://saekdam.kro.kr/auth/oauth2/kakao/callback')) {
              final uri = Uri.parse(url);
              final code = uri.queryParameters['code'];
              if (code != null) {
                _fetchJwtWithCode(code);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.loginUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('카카오 로그인'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  Future<void> _fetchJwtWithCode(String code) async {
    try {
      final uri = Uri.parse('https://saekdam.kro.kr/api/auth/oauth2/kakao/callback?code=$code');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jwt = utf8.decode(response.bodyBytes);

        // JWT 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', jwt);

        // 로그인 성공 → 웹뷰 닫으면서 'SUCCESS' 결과 전달
        Navigator.pop(context, 'SUCCESS');
      } else {
        // 실패 시 메시지
        final decoded = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final errorMessage = decoded['message'] ?? '카카오 로그인 실패';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카카오 JWT 발급 에러: $e')),
      );
    }
  }
}

