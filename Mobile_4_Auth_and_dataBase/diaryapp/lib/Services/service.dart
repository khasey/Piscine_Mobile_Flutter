import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileTop extends StatefulWidget {
  const ProfileTop({super.key});

  @override
  State<ProfileTop> createState() => _ProfileTopState();
}

class _ProfileTopState extends State<ProfileTop> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;
    if (user != null && user!.photoURL != null) {
      backgroundImage = NetworkImage(user!.photoURL!);
    } else {
      // Utilisez une image par défaut si l'URL de la photo n'est pas disponible
      backgroundImage = const NetworkImage('https://i.imgur.com/BoN9kdC.png');
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            margin: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 120,
              height: 120,
              child: CircleAvatar(
                backgroundImage: backgroundImage,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            user?.displayName ?? 'Username',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DialogEntry extends StatefulWidget {
  const DialogEntry({super.key});

  @override
  State<DialogEntry> createState() => _DialogEntryState();
}

class _DialogEntryState extends State<DialogEntry> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController entryController = TextEditingController();

  var parser = EmojiParser();
  var coffee = Emoji('coffee', '☕');
  var heart  = Emoji('heart', '❤️');

  @override
  void dispose() {
    titleController.dispose();
    entryController.dispose();
    super.dispose();
  }

  Future<void> saveEntry() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        await FirebaseFirestore.instance.collection('notes').doc().set({
          'userId': userId,
          'title': titleController.text,
          'entry': entryController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        Navigator.pop(context);
      } catch (e) {
        print('Erreur lors de la sauvegarde des données : $e');
      }
    } else {
      print('Utilisateur non connecté');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height / 1.5,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 14,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.2,
                child: TextField(
                  controller: entryController,
                  maxLines: 20,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Entry',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: const Size(280, 50),
                elevation: 5,
                shadowColor: Colors.black,
              ),
              child: const Text('ADD ENTRY',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              onPressed: saveEntry,
            ),
          ],
        ),
      ),
    );
  }
}
