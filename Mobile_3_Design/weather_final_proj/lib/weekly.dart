import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weekly extends StatefulWidget {
  final bool isGeoLocationEnabled;
  final String cityName;
  final double? latitude;
  final double? longitude;

  const Weekly(
      {super.key,
      required this.isGeoLocationEnabled,
      required this.cityName,
      this.latitude,
      this.longitude});

  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  List<Map<String, dynamic>> weeklyWeather = [];

  @override
  void initState() {
    super.initState();
    if (widget.latitude != null && widget.longitude != null) {
      getWeeklyWeather();
    }
  }

    void showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

  Future<void> getWeeklyWeather() async {
    try {
      String timezone = "GMT";
      String apiUrl =
          'https://api.open-meteo.com/v1/forecast?latitude=${widget.latitude}&longitude=${widget.longitude}&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_sum,rain_sum,showers_sum&timezone=$timezone';
      final response = await http.get(Uri.parse(apiUrl));
      print(
          "Weekly weather API response: ${response.body}"); // Ajoutez ceci pour afficher la réponse

      if (response.statusCode == 200) {
        var data = json.decode(
            response.body); // Ajoutez ceci pour afficher les données (JSON

        List dailyData = data['daily']['time'] ?? [];
        List maxTemps = data['daily']['temperature_2m_max'] ?? [];
        List minTemps = data['daily']['temperature_2m_min'] ?? [];
        List weatherCodes = data['daily']['weathercode'] ??
            []; // Assurez-vous que cette clé existe

        print("weathercode : $weatherCodes");
        if (dailyData.isNotEmpty) {
          setState(() {
            weeklyWeather = List.generate(dailyData.length, (index) {
              return {
                "date": dailyData[index],
                "minTemp": index < minTemps.length
                    ? minTemps[index].toString()
                    : "N/A",
                "maxTemp": index < maxTemps.length
                    ? maxTemps[index].toString()
                    : "N/A",
                "weatherDescription": index < weatherCodes.length
                    ? getWeatherDescription(weatherCodes[index])
                    : "Unknown",
              };
            });
          });
        }
      }
      else{
        showError('Failed to fetch weekly weather');
      }
    } catch (e) {
      print('Error fetching weekly weather: $e');
    }
  }

  String getWeatherDescription(int code) {
    if (code >= 0 && code <= 19) {
      return "Cloudy";
    } else if (code >= 20 && code <= 29) {
      if (code == 20) return "Drizzle";
      if (code == 21) return "Rain";
      if (code == 22) return "Snow";
      if (code == 23) return "Rain and snow";
      if (code == 24) return "Freezing rain";
      if (code == 25) return "Shower of rain";
      if (code == 26) return "Shower of snow";
      if (code == 27) return "Shower of hail";
      if (code == 28) return "Fog";
      if (code == 29) return "Thunderstorm";
    } else if (code >= 30 && code <= 32) {
      return "Slight sandstorm";
    } else if (code >= 33 && code <= 35) {
      return "Severe sandstorm";
    }
    // if (code >= 36) return "Slight blowing snow";
    // if (code >= 37) return "Heavy drifting snow";
    // if (code >= 38) return "Slight blowing snow";
    // if (code >= 39) {
    //   return "Heavy drifting snow";
     else if (code >= 40 && code <= 49) {
      return "Fog";
    } else if (code >= 50 && code <= 59) {
      return "Drizzle";
    } else if (code >= 60 && code <= 69) {
      return "Rain";
    } else if (code >= 70 && code <= 79) {
      if (code == 70) return "Intermittent fall of snowflakes";
      if (code == 71) return "Continuous fall of snowflakes";
      if (code == 72) return "Intermittent fall of snowflakes";
      if (code == 73) return "Continuous fall of snowflakes";
      if (code == 74) return "Intermittent fall of snowflakes";
      if (code == 75) return "Continuous fall of snowflakes";
      if (code == 76) return "Diamond dust";
      if (code == 77) return "Snow grains";
      if (code == 78) return "Isolated star-like snow crystals";
      if (code == 79) return "Ice pellets";
    } else if (code >= 80 && code <= 84) {
      return "Rain";
    } else if (code >= 85 && code <= 90) {
      return "Snow";
    } else if (code >= 95 && code <= 99) {
      return "Thunderstorm";
    }
    return "Unknown";
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (locationInfo['city']!.isNotEmpty)
                  Text('${locationInfo['city']}',
                      style: const TextStyle(fontSize: 20)),
                if (locationInfo['region']!.isNotEmpty)
                  Text('${locationInfo['region']}',
                      style: const TextStyle(fontSize: 20)),
                if (locationInfo['country']!.isNotEmpty)
                  Text('${locationInfo['country']}',
                      style: const TextStyle(fontSize: 20)),
                for (var dayWeather in weeklyWeather)
                  ListTile(
                    title: Text(
                        '${dayWeather["date"]} - Min: ${dayWeather["minTemp"]}°C, Max: ${dayWeather["maxTemp"]}°C, Weather: ${dayWeather["weatherDescription"]}'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
