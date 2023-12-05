import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello World', style: TextStyle(fontSize: 20)),
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

void press() {
  print('Button pressed');
}
