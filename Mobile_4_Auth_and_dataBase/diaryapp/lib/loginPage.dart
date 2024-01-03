import 'package:diaryapp/diaryPage.dart';
import 'package:diaryapp/myHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:simple_icons/simple_icons.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:github_sign_in/github_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> signInWithGoogle() async {
    try {
      print('Connexion Google en cours...');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print('googleUser --->>>> $googleUser');

      if (googleUser == null) return; // L'utilisateur a annulé la connexion
        print('Connexion Google annulée par l\'utilisateur');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      print('Connexion réussie');
      // Redirection vers la page d'accueil après la connexion réussie
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DiaryPage()),
      );
    } catch (error) {
      print('Erreur ----> BITE');
      // Gérer l'erreur ici
      print('Erreur de connexion Google: $error');
    }
  }

  Future<void> signInWithGitHub(BuildContext context) async {
    try {
      // Initialisation de GitHubSignIn
      final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: dotenv.env['GITHUB_CLIENT_ID']!,
        clientSecret: dotenv.env['GITHUB_SECRET']!,
        redirectUrl: dotenv.env['GITHUB_REDIRECT_URL']!,
      );

      // Tentative de connexion avec GitHub
      final result = await gitHubSignIn.signIn(context);

      if (result.token != null) {
        // Création de la credential avec le token d'accès
        final AuthCredential credential =
            GithubAuthProvider.credential(result.token!);

        // Tentative de connexion à Firebase
        await FirebaseAuth.instance.signInWithCredential(credential);
        print('Connexion Github réussie');
        // Redirection vers la page d'accueil après connexion réussie
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DiaryPage()),
        );
      } else {
        // Gérer l'erreur ou l'annulation ici
        print('Erreur ou annulation lors de la connexion GitHub');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // Gestion du compte existant avec des informations d'identification différentes
        String email = e.email!;
        print(
            'Compte existant avec des informations d\'identification différentes: $email');
        AuthCredential pendingCredential = e.credential!;
        print('Informations d\'identification en attente: $pendingCredential');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Compte existant'),
            content: const Text(
                'Un compte existe déjà avec le même email mais avec des méthodes de connexion différentes. Veuillez utiliser la méthode de connexion originale.'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(), // Fermer la boîte de dialogue
                child: const Text('OK'),
              ),
            ],
          ),
        );
        // Ici, vous pouvez demander à l'utilisateur de se connecter avec la méthode originale
        // ou lier les comptes, selon votre logique d'application
      } else {
        // Gérer les autres erreurs Firebase
        print('Erreur Firebase lors de la connexion GitHub: ${e.message}');
      }
    } catch (e) {
      // Gérer les autres erreurs
      print('Erreur lors de la connexion GitHub: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/461.jpg"), // Remplacez par le chemin de votre image
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              title: const Text('L O G I N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
              shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ] 
                    ,
              )),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
              )),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text('Choose your way to log:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white, 
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ] 
                    ,)),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        fixedSize: const Size(280, 50),
                        elevation: 5,
                        shadowColor: Colors.black
                        ),
                    onPressed: () {
                      signInWithGoogle();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(SimpleIcons.google, color: Colors.black),
                        SizedBox(width: 10),
                        Text('G O O G L E',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    )),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        fixedSize: const Size(280, 50),
                        elevation: 5,
                        shadowColor: Colors.black),
                    onPressed: () {
                      signInWithGitHub(context);
                      // .then((value) => print('Connexion réussie'))
                      // .catchError((error) => print('Erreur de connexion'));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(SimpleIcons.github, color: Colors.black),
                        SizedBox(width: 10),
                        Text('G I T H U B',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    )),
              ),
              const SizedBox(height: 40),
            ],
          )),
    );
  }
}
