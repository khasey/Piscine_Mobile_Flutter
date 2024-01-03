import 'package:flutter/material.dart';

class TextEdit extends StatefulWidget {
  const TextEdit({super.key});

  @override
  State<TextEdit> createState() => _TextEditState();
}

class _TextEditState extends State<TextEdit> {
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
                margin: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1,
                  height: MediaQuery.of(context).size.height / 1.4,
                  
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}