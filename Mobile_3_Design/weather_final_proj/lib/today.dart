import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Today extends StatefulWidget {
  final bool isGeoLocationEnabled;
  final String cityName;
  final double? latitude;
  final double? longitude;

  const Today(
      {super.key,
      required this.isGeoLocationEnabled,
      required this.cityName,
      this.latitude,
      this.longitude});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  List<Map<String, dynamic>> hourlyWeather = [];

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  void didUpdateWidget(Today oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.latitude != oldWidget.latitude ||
        widget.longitude != oldWidget.longitude) {
      getWeather();
    }
  }

  void showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

  Future<void> getWeather() async {
    if (widget.latitude == null || widget.longitude == null) return;

    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=${widget.latitude}&longitude=${widget.longitude}&hourly=temperature_2m,windspeed_10m'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String today = DateTime.now()
            .toIso8601String()
            .substring(0, 10); // Format YYYY-MM-DD

        List<Map<String, dynamic>> tempHourlyWeather = []; // Liste temporaire

        List hourlyData = data['hourly']['time'];
        List temperatures = data['hourly']['temperature_2m'];
        List windSpeeds = data['hourly']['windspeed_10m'];

        for (int i = 0; i < hourlyData.length; i++) {
          String time = hourlyData[i];
          if (time.startsWith(today)) {
            // Filtrer pour n'afficher que les heures d'aujourd'hui
            tempHourlyWeather.add({
              "time": time.substring(11, 16), // Heure seulement
              "temperature": temperatures[i].toString(),
              "windSpeed": windSpeeds[i].toString()
            });
          }
        }

        setState(() {
          hourlyWeather = tempHourlyWeather; // Affecter à la variable d'état
        });
      }
      else{
        showError('Failed to fetch weather');
      }
    } catch (e) {
      showError('Failed to fetch weather');
      print('Error fetching weather: $e');
    }
  }

  Map<String, String> parseCityName(String cityName) {
    List<String> parts = cityName.split(',').map((e) => e.trim()).toList();
    String city = parts.isNotEmpty ? parts[0] : '';
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
        children: <Widget>[
          Expanded(
            // Permet à la ListView de prendre tout l'espace vertical disponible
            child: ListView(
              children: <Widget>[
                if (locationInfo['city']!.isNotEmpty)
                  Center(
                    // Centre horizontalement
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${locationInfo['city']}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${locationInfo['region']}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${locationInfo['country']}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                // Répétez ce schéma pour les autres éléments (région et pays)
                for (var hourData in hourlyWeather)
                  Center(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${hourData["time"]} ${hourData["temperature"]}°C ${hourData["windSpeed"]} km/h',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    ),// Centre horizontalement
              ],
            ),
          ),
        ],
      ),
    );
  }
}
