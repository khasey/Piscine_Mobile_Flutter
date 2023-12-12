import 'package:flutter/material.dart';
import 'package:weather_final_proj/bottomBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/images/background.jpg"), // Remplacez avec votre image d'arrière-plan
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
