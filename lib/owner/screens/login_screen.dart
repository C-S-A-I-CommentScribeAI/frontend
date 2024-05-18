import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:frontend/owner/screens/choose_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isIDValid = true; // 아이디 유효성
  late String serverAddress;
  late String tokenAddress;
  bool isChecked = false;
  bool _isPasswordValid = true;
  bool _isPasswordVisible = false;
  TextEditingController idController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController(); // 비밀번호 입력을 위한 Controller 추가

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendDataToServer() async {
    final prefs = await SharedPreferences.getInstance(); // 앱 내부에 저장된 토큰 값을 가져옴
    final accessToken = prefs.getString('accessToken') ?? '';
    final refreshToken = prefs.getString('refreshToken') ?? '';

    if (Platform.isAndroid) {
      tokenAddress = 'http://10.0.2.2:9000/api/v1/auth/refresh';
    } else if (Platform.isIOS) {
      tokenAddress = 'http://127.0.0.1:9000/api/v1/auth/refresh';
    }

    final url = Uri.parse(tokenAddress);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // access token을 헤더에 포함
      },
      body: jsonEncode(<String, String>{
        'refreshToken': refreshToken, // 필요에 따라 refresh token을 포함
      }),
    );

    if (response.statusCode == 200) {
      print('데이터 전송 성공!');
      print(accessToken);
      print(refreshToken);
    } else {
      print('데이터 전송 실패! ${response.body}');
    }
  }

  // 로그인 API
  Future<void> handleLogin(String userId, String password) async {
    try {
      if (Platform.isAndroid) {
        serverAddress = 'http://10.0.2.2:9000/api/v1/auth/login';
      } else if (Platform.isIOS) {
        serverAddress = 'http://127.0.0.1:9000/api/v1/auth/login';
      }

      final url = Uri.parse(serverAddress);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          'userId': userId,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final accessToken = responseData['accessToken'];
        final refreshToken = responseData['refreshToken'];

        // 토큰 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);

        print('로그인 성공');
      } else {
        print('로그인 실패 ${response.body}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '배달반도',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 55,
                child: TextField(
                  controller: idController,
                  maxLength: 10, // 아이디의 최대 길이를 10으로 제한
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: _isIDValid ? '아이디' : '',
                    labelStyle: const TextStyle(fontSize: 13),
                    counterText: '',
                    errorText: _isIDValid
                        ? null
                        : idController.text.length < 4 &&
                                idController.text.length > 10
                            ? '4자 이상 10자 이하로 작성해주세요.'
                            : '',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isIDValid = !_isIDValid;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12.0),
              PasswordTextField(
                isPasswordValid: _isPasswordValid,
                isPasswordVisible: _isPasswordVisible,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty ||
                        value.length < 10 ||
                        !RegExp(r'(?=.*[a-zA-Z])(?=.*[!@#$%^&*()_+])(?=.*[0-9]).{10,}')
                            .hasMatch(value)) {
                      _isPasswordValid = false;
                    } else {
                      _isPasswordValid = true;
                    }
                  });
                },
                onVisibilityToggle: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                controller: _passwordController,
              ),
              const SizedBox(height: 1.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          '자동로그인',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '아이디',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '|',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '비밀번호',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '찾기',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: SizedBox(
                  height: 45,
                  width: 400,
                  child: TextButton(
                    onPressed: () {
                      // sendDataToServer();

                      String userId = idController.text;
                      String password = _passwordController.text;
                      handleLogin(userId, password);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff374AA3)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChoosePage()));
                  },
                  child: const Text(
                    '처음이신가요?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

class PasswordTextField extends StatelessWidget {
  final bool isPasswordValid;
  final bool isPasswordVisible;
  final ValueChanged<String> onChanged;
  final VoidCallback? onVisibilityToggle;
  final TextEditingController controller;

  const PasswordTextField({
    super.key,
    required this.isPasswordValid,
    required this.isPasswordVisible,
    required this.onChanged,
    this.onVisibilityToggle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: controller,
            obscureText: !isPasswordVisible,
            onChanged: onChanged,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              labelText: isPasswordValid ? '비밀번호' : '',
              labelStyle: const TextStyle(fontSize: 13),
              errorText: isPasswordValid
                  ? null
                  : '비밀번호는 적어도 하나의 영문자, 특수문자 포함 10자 이상이어야 합니다.',
            ),
          ),
          Positioned(
            right: 0,
            top: isPasswordValid ? 6 : -10,
            child: TextButton(
              onPressed: onVisibilityToggle,
              child: Text(
                isPasswordVisible ? '숨기기' : '보기',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}