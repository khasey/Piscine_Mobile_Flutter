import 'package:flutter/material.dart';

class Today extends StatefulWidget {
  
  final bool isGeoLocationEnabled;
  final String cityName;

  const Today({super.key, required this.isGeoLocationEnabled, required this.cityName});
  

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Today', style: TextStyle(fontSize: 40)),
          Text(
            widget.isGeoLocationEnabled ? 'Geolocalisation' : widget.cityName,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}