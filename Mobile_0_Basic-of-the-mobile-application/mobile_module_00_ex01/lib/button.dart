import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isPress = false;

  void press() {
    setState(() {
      isPress = !isPress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isPress ? 'Simple Text' : 'Hello Wolrd!', style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: press,
              child: Text('Press me'),
            ),
          ],
        ),
      ),
    );
  }
}
