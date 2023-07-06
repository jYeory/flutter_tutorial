import 'package:flutter/material.dart';
import 'package:flutter_week01/firstTab.dart';
import 'package:flutter_week01/secondTab.dart';
import 'package:flutter_week01/thirdTab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyAccountBook(title: '그냥 가계부'),
    );
  }
}

class MyAccountBook extends StatefulWidget {
  const MyAccountBook({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _MyAccountBookState();
}

class _MyAccountBookState extends State<MyAccountBook> {
  int _currentIndex = 0;
  final List<Widget> _children = [FirstTab(), SecondTab(), ThirdTab()];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Hello Flutter',
            style: TextStyle(fontSize: 28),
          ),
          centerTitle: true,
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: 'Alarm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.nightlight_round),
              label: 'Sleep',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _onTap,
        ));
  }
}
