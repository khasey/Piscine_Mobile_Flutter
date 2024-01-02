import 'package:diaryapp/Services/service.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1,
                  height: MediaQuery.of(context).size.height / 6,
                  child: const ProfileTop(),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1,
                  height: MediaQuery.of(context).size.height / 5,
                ),
              ),
              Card(
                margin: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1,
                  height: MediaQuery.of(context).size.height / 4,
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
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => const AlertDialog(
                    title: Text('ADD A NEW ENTRY',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    // titlePadding: EdgeInsets.all(15),
                    // contentPadding: EdgeInsets.all(45),
                    // content: Text('HERE YOU CAN ADD A TITLE AND A TEXT'),
                    actions: <Widget>[
                        DialogEntry(
                          key: Key('dialog_entry'),
                        ),
                      ],
                  ),
                ),
                child: const Text('N E W  E N T R Y',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
