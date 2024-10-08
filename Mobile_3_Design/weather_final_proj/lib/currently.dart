import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_final_proj/services/weather_service.dart';

class Currently extends StatefulWidget {
  final bool isGeoLocationEnabled;
  final String cityName;
  final double? latitude;
  final double? longitude;
  final String? errorMessageGeolocation; // Ajout de la variable d'erreur

  const Currently(
      {super.key,
      required this.isGeoLocationEnabled,
      required this.cityName,
      this.errorMessageGeolocation,  // Ajout de la variable d'erreur ici
      this.latitude,
      this.longitude});

  @override
  State<Currently> createState() => _CurrentlyState();
}

class _CurrentlyState extends State<Currently> {
  String? temperature;
  String? windSpeed;
  int? code;
  String? weatherCodeValue;

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

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> getWeather() async {
    if (widget.latitude == null || widget.longitude == null) return;

    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=${widget.latitude}&longitude=${widget.longitude}&hourly=temperature_2m,windspeed_10m,weather_code'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          temperature = data['hourly']['temperature_2m'][0].toString();
          windSpeed = data['hourly']['windspeed_10m'][0].toString();
          code = data['hourly']['weather_code'][0];
        });
      } else {
        showError('Failed to fetch weather');
      }
    } catch (e) {
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
      body: Center(
        child: widget.errorMessageGeolocation != null && widget.errorMessageGeolocation!.isNotEmpty
            ? Text(
                widget.errorMessageGeolocation!, // Affiche le message d'erreur centré
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (locationInfo['city'] != '')
                    Center(
                      child: Text(
                        '${locationInfo['city']}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(243, 236, 250, 1),
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (locationInfo['region'] != '' &&
                      locationInfo['country'] != '')
                    Center(
                      child: Text(
                        '${locationInfo['region']}, ${locationInfo['country']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(243, 236, 250, 1),
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (temperature != null)
                    Center(
                      child: Text(
                        '$temperature °C',
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(243, 236, 250, 1),
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (windSpeed != null)
                    WeatherService.getWeatherDescriptionWidget(code!),
                  const SizedBox(
                    height: 20,
                  ),
                  if (windSpeed != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wind_power_rounded,
                          size: 30,
                          color: Color.fromRGBO(243, 236, 250, 1),
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        Text(
                          '$windSpeed km/h',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(243, 236, 250, 1),
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}
