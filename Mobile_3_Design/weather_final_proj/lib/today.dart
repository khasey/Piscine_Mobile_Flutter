import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_final_proj/services/weather_service.dart';

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

  Future<void> getWeather() async {
    if (widget.latitude == null || widget.longitude == null) {
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=${widget.latitude}&longitude=${widget.longitude}&hourly=temperature_2m,windspeed_10m,weather_code'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String today = DateTime.now().toIso8601String().substring(0, 10);

        List<Map<String, dynamic>> tempHourlyWeather = [];
        List hourlyData = data['hourly']['time'];
        List temperatures = data['hourly']['temperature_2m'];
        List windSpeeds = data['hourly']['windspeed_10m'];
        List weatherCodes = data['hourly']['weather_code'];

        for (int i = 0; i < hourlyData.length; i++) {
          String time = hourlyData[i];
          if (time.startsWith(today)) {
            tempHourlyWeather.add({
              "time": time.substring(11, 16),
              "temperature": temperatures[i].toString(),
              "windSpeed": windSpeeds[i].toString(),
              "weatherCode": weatherCodes[i],
            });
          }
        }

        setState(() {
          hourlyWeather = tempHourlyWeather;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch weather')));
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
    if (hourlyWeather.isEmpty) {
      return LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
      );
    }

    List<FlSpot> spots = hourlyWeather.asMap().entries.map((entry) {
      int idx = entry.key;
      double temp = double.tryParse(entry.value["temperature"]) ?? 0.0;
      return FlSpot(idx.toDouble(), temp);
    }).toList();

    return LineChartData(
      backgroundColor: const Color.fromRGBO(243, 236, 250, 1),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 4,
            getTitlesWidget: (value, meta) {
              return Text(hourlyWeather[value.toInt()]["time"],
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
                      // fontWeight: FontWeight.bold,
                      fontSize: 12));
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            interval: 0.7,
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
                      // decoration: TextDecoration.underline,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15));
            },
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return const Text('');
            },
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: hourlyWeather.length.toDouble() - 1,
      minY: hourlyWeather
          .map((e) => double.tryParse(e["temperature"]) ?? 0.0)
          .reduce(math.min),
      maxY: hourlyWeather
          .map((e) => double.tryParse(e["temperature"]) ?? 0.0)
          .reduce(math.max),
      lineBarsData: [
        LineChartBarData(
          // aboveBarData: BarAreaData(show: true, color: Colors.orange, cutOffY: 100),
          // belowBarData: BarAreaData(show: true, colors: [Colors.amber.withOpacity(0.5)]),
          spots: spots,
          isCurved: true,
          preventCurveOverShooting: true,
          curveSmoothness: 0.5,
          color: Colors.black,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> locationInfo = parseCityName(widget.cityName);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (locationInfo['city'] != '') const SizedBox(height: 30),
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
                const SizedBox(height: 5),
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
                // ============================================================

                const SizedBox(height: 20),
                SizedBox(
                  width: 300, // Modifiez cette valeur pour ajuster la largeur
                  height: 300, // Hauteur du graphique
                  child: LineChart(mainData()),
                ),

                // ============================================================
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: hourlyWeather.map((hourData) {
                      return Card(
                        color: Color.fromARGB(39, 243, 236, 250),
                        margin: const EdgeInsets.all(5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${hourData["time"]}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:Color.fromRGBO(243, 236, 250, 1),
                                      )),
                              const SizedBox(height: 10),
                              WeatherService.getWeatherDescriptionWidgetToday(
                                  hourData["weatherCode"]),
                              const SizedBox(height: 10),
                              Text('${hourData["temperature"]}°C',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:Color.fromRGBO(243, 236, 250, 1),
                                      )),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.wind_power,
                                    size: 15,
                                    color:Color.fromRGBO(243, 236, 250, 1),
                                  ),
                                  Text('${hourData["windSpeed"]} km/h',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color:Color.fromRGBO(243, 236, 250, 1),
                                          )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
