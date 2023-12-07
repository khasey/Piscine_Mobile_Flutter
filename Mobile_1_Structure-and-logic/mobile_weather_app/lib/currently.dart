// Purpose: Currently page for the mobile weather app
import 'package:flutter/material.dart';

class Currently extends StatefulWidget {
  const Currently({super.key});

  @override
  State<Currently> createState() => _CurrentlyState();
}

class _CurrentlyState extends State<Currently> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Currently', style: TextStyle(fontSize: 40)));
  }
}