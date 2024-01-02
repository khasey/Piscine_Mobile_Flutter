import 'package:diaryapp/Services/profile.dart';
import 'package:diaryapp/Services/text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diaryapp/loginPage.dart'; // Assurez-vous que le chemin d'importation est correct

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {

  int currentPageIndex = 0;

  final PageController pageController = PageController();

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/461.jpg"), // Remplacez par le chemin de votre image
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Diary App'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: signOut,
              tooltip: 'Déconnexion',
            ),
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          children: const [
            Profile(),
            TextEdit(),
            
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentPageIndex,
            onTap: (int index) {
              setState(() {
                currentPageIndex = index;
              });
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'New Entry',
              ),
            ],
          ),
      ),
    );
  }
}
