import 'package:diaryapp/diaryPage.dart';
// Importez votre page de login
import 'package:diaryapp/myHomePage.dart'; // Importez votre page d'accueil (si nécessaire)
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("inside ----> $snapshot.data");
            // L'utilisateur est connecté, rediriger vers la page d'accueil
            return const DiaryPage();
          }
          print("ici ---->  $snapshot.data");
          // L'utilisateur n'est pas connecté, afficher la page de login
          return const MyHomePage();
        },
      ),
    );
  }
}
