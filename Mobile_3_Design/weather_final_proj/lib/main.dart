import 'package:flutter/material.dart';
import 'package:weather_final_proj/bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // foregroundDecoration: const BoxDecoration(
      //   image: DecorationImage(
      //     alignment: Alignment.center,
      //     image: AssetImage("assets/back.jpg"),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.center,
          image: AssetImage("assets/back.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: MaterialApp(
        title: 'Meteo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const BottomBar(),
      ),
    );
  }
}
