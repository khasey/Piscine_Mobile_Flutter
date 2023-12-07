// Purpose: Currently page for the mobile weather app
import 'package:flutter/material.dart';

class Currently extends StatefulWidget {
  final bool isGeoLocationEnabled;
  final String cityName;

  const Currently({super.key, required this.isGeoLocationEnabled, required this.cityName});

  @override
  State<Currently> createState() => _CurrentlyState();
}

class _CurrentlyState extends State<Currently> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Currently', style: TextStyle(fontSize: 40)),
          if(widget.cityName.isNotEmpty)
            Text( widget.cityName, style: const TextStyle(fontSize: 20),
          ), 
        ],
      ),
    );
  }
}