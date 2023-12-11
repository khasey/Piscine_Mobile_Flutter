import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Currently extends StatefulWidget {
  final bool isGeoLocationEnabled;
  final String cityName;
  final double? latitude;
  final double? longitude;
  

  const Currently(
      {super.key,
      required this.isGeoLocationEnabled,
      required this.cityName,
      this.latitude,
      this.longitude});

  @override
  State<Currently> createState() => _CurrentlyState();
}

class _CurrentlyState extends State<Currently> {
  String? temperature;
  String? windSpeed;

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  void didUpdateWidget(Currently oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.latitude != oldWidget.latitude ||
        widget.longitude != oldWidget.longitude) {
      getWeather();
    }
  }

  Future<void> getWeather() async {
    if (widget.latitude == null || widget.longitude == null) return;

    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=${widget.latitude}&longitude=${widget.longitude}&hourly=temperature_2m,windspeed_10m'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          temperature = data['hourly']['temperature_2m'][0].toString();
          windSpeed = data['hourly']['windspeed_10m'][0].toString();
        });
      }
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

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
          if (temperature != null)
            Text('$temperature °C',
                style: const TextStyle(fontSize: 20)),
          if (windSpeed != null)
            Text('$windSpeed km/h',
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
