import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_final_proj/services/weather_service.dart';

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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> getWeeklyWeather() async {
    try {
      String timezone = "GMT";
      String apiUrl =
          'https://api.open-meteo.com/v1/forecast?latitude=${widget.latitude}&longitude=${widget.longitude}&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_sum,rain_sum,showers_sum&timezone=$timezone';
      final response = await http
          .get(Uri.parse(apiUrl)); // Ajoutez ceci pour afficher la réponse

      if (response.statusCode == 200) {
        var data = json.decode(
            response.body); // Ajoutez ceci pour afficher les données (JSON

        List dailyData = data['daily']['time'] ?? [];
        List maxTemps = data['daily']['temperature_2m_max'] ?? [];
        List minTemps = data['daily']['temperature_2m_min'] ?? [];
        List weatherCodes = data['daily']['weathercode'] ??
            []; // Assurez-vous que cette clé existe
        print(weatherCodes);
        if (dailyData.isNotEmpty) {
          setState(() {
            weeklyWeather = List.generate(dailyData.length, (index) {
              return {
                "date": dailyData[index].substring(5),
                "minTemp": index < minTemps.length
                    ? minTemps[index].toString()
                    : "N/A",
                "maxTemp": index < maxTemps.length
                    ? maxTemps[index].toString()
                    : "N/A",
                "weatherDescription": weatherCodes[index],
              };
            });
          });
        }
      } else {
        showError('Failed to fetch weekly weather');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching weekly weather: $e');
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

  LineChartData mainData() {
    if (weeklyWeather.isEmpty) {
      return LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
      );
    }

    // Création des spots pour les températures max et min
    List<FlSpot> maxTempSpots = [];
    List<FlSpot> minTempSpots = [];
    for (var i = 0; i < weeklyWeather.length; i++) {
      maxTempSpots
          .add(FlSpot(i.toDouble(), double.parse(weeklyWeather[i]['maxTemp'])));
      minTempSpots
          .add(FlSpot(i.toDouble(), double.parse(weeklyWeather[i]['minTemp'])));
    }

    return LineChartData(
      backgroundColor: Color.fromRGBO(243, 236, 250, 1),
      titlesData: FlTitlesData(
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 25,
            getTitlesWidget: (value, meta) {
              return const Text('',
                  style: TextStyle(color: Color(0xff67727d), fontSize: 15));
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return Text(
                weeklyWeather[value.toInt()]["date"],
                style: const TextStyle(
                  color: Color.fromRGBO(243, 236, 250, 1),
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            getTitlesWidget: (value, meta) {
              return Text('${value.toInt()}°',
                  style: const TextStyle(
                    color: Color.fromRGBO(243, 236, 250, 1),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ));
            },
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            getTitlesWidget: (value, meta) {
              return const Text('',
                  style: TextStyle(color: Color(0xff67727d), fontSize: 15));
            },
          ),
        ),
      ),

      // ... Configuration du graphique ...
      lineBarsData: [
        LineChartBarData(
          spots: maxTempSpots,
          isCurved: true,
          color: Colors.red,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
        LineChartBarData(
          spots: minTempSpots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      // ... Autres configurations ...
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> locationInfo = parseCityName(widget.cityName);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: [
                    if (locationInfo['city'] != '') const SizedBox(height: 20),
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
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  height: 300, // Hauteur fixe pour le graphique
                  padding: const EdgeInsets.all(8.0),
                  child: LineChart(mainData()),
                ),

                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: weeklyWeather.map((dayWeather) {
                      return Container(
                        width: 120,
                        height: 150,
                        margin: const EdgeInsets.all(0),
                        child: Card(
                          color: Color.fromARGB(39, 243, 236, 250),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                '${dayWeather["date"]}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromRGBO(243, 236, 250, 1),
                                  // shadows: [
                                  //   Shadow(
                                  //     blurRadius: 10.0,
                                  //     color: Colors.white,
                                  //     offset: Offset(0, 0),
                                  //   ),
                                  // ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              WeatherService.getWeatherDescriptionWidgetToday(
                                  dayWeather["weatherDescription"]),
                              const SizedBox(height: 10),
                              Text('${dayWeather["maxTemp"]}°C max',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color.fromRGBO(243, 236, 250, 1),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Color.fromARGB(255, 240, 0, 0),
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  )),
                              Text('${dayWeather["minTemp"]}°C min',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color.fromRGBO(243, 236, 250, 1),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Color.fromARGB(255, 0, 0, 255),
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // for (var dayWeather in weeklyWeather)
                //   ListTile(
                //     title: Text(
                //         '${dayWeather["date"]} - Min: ${dayWeather["minTemp"]}°C, Max: ${dayWeather["maxTemp"]}°C, Weather: ${dayWeather["weatherDescription"]}'),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
