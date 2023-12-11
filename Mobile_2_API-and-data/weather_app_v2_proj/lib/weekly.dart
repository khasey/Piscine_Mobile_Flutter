import 'package:flutter/material.dart';

class Weekly extends StatefulWidget {
  final bool isGeoLocationEnabled;
  final String cityName;
  final double? latitude;
  final double? longitude;

  const Weekly({super.key, required this.isGeoLocationEnabled, required this.cityName, this.latitude, this.longitude});




  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {

  Map<String, String> parseCityName(String cityName) {
  List<String> parts = cityName.split(',').map((e) => e.trim()).toList();
  print(parts);
  String city = parts.length > 0 ? parts[0] : '';
  String region = parts.length > 1 ? parts[1] : '';
  String country = parts.length > 2 ? parts[2] : '';

  return {
    'city': city,
    'region': region,
    'country': country,
  };
}
  @override
  Widget build(BuildContext context) {
    Map<String, String> locationInfo = parseCityName(widget.cityName);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (locationInfo['city'] != '')
            Text('${locationInfo['city']}',
                style: const TextStyle(fontSize: 20)),
          if (locationInfo['region'] != '')
            Text('${locationInfo['region']}',
                style: const TextStyle(fontSize: 20)),
          if (locationInfo['country'] != '')
            Text('${locationInfo['country']}',
                style: const TextStyle(fontSize: 20)),
          if (widget.cityName == "error")
            const Text(
              'Geolocation is not available, please enable it on your app setting',
              style: TextStyle(fontSize: 20, color: Colors.red),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}