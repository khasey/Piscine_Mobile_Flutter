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
          if(widget.cityName != "error")
            const Text('Today', style: TextStyle(fontSize: 40)),
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