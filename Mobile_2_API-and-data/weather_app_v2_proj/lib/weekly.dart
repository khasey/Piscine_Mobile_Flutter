import 'package:flutter/material.dart';

class Weekly extends StatefulWidget {
  final bool isGeoLocationEnabled;
  final String cityName;
  const Weekly({super.key, required this.isGeoLocationEnabled, required this.cityName});

  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(widget.cityName != "error")
            const Text('Weekly', style: TextStyle(fontSize: 40)),
          if(widget.cityName.isNotEmpty && widget.cityName != "error")
            Text( widget.cityName, style: const TextStyle(fontSize: 20),
            ),
          if(widget.cityName == "error")
            const Text('Geolocation is not available, please enable it on your app settin',
             style: TextStyle(fontSize: 20, color: Colors.red),
             textAlign: TextAlign.center,
             ),  
        ],
      ),
    );
  }
}