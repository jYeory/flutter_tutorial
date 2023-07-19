import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

/// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getQuiz();
  }

  void getQuiz() async {
    String trivia = await getNumberTrivia();
    setState(() {
      quiz = trivia;
    });
  }

  String quiz = "Quiz";

  /// Numbers API 호출하기
  Future<String> getNumberTrivia() async {
    // get 메소드로 URL 호출
    Response result = await Dio().get('http://numbersapi.com/random/trivia');
    String trivia = result.data; // 응답 결과 가져오기
    return trivia;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // quiz
              Expanded(
                child: Center(
                  child: Text(
                    quiz,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // New Quiz 버튼
              SizedBox(
                height: 42,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () async {
                    // New Quiz 클릭시 퀴즈 가져오기
                    getQuiz();
                  },
                  child: Text(
                    "New Quiz",
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 24,
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
