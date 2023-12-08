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
          if(widget.cityName != "error")
            const Text('Currently', style: TextStyle(fontSize: 40)),
          if(widget.cityName.isNotEmpty && widget.cityName != "error")
            Text( widget.cityName, style: const TextStyle(fontSize: 20),
            ),
          if(widget.cityName == "error")
            const Text('Geolocation is not available, please enable it on your app setting',
             style: TextStyle(fontSize: 20, color: Colors.red),
             textAlign: TextAlign.center,
             ),  
        ],
      ),
    );
  }
}