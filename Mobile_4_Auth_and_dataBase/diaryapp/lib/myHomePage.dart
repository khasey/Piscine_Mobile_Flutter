import 'package:diaryapp/loginPage.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/461.jpg"), // Remplacez par le chemin de votre image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const Center(
            //   child: Text(
            //     'Welcome to your Diary App',
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            //   ),
            // ),
            // const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(280, 50),
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text('L O G I N',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
