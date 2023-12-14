import 'package:flutter/material.dart';

class WeatherService {
  static Widget getWeatherDescriptionWidget(int code){
    IconData icon;
    String description;

    if(code >= 0 &&  code <= 1){
      icon = Icons.sunny;
      description = "Sunny";
    }
    else if(code >= 2 && code <= 3){
      icon = Icons.water_drop;
      description = "Drizzle";
    }
    else if(code >= 4 && code  <= 5){
      icon = Icons.cloud;
      description = "Cloudy";
    }
    else if(code >= 6 && code  <= 11){
      icon = Icons.foggy;
      description = "Foggy";
    }
    else if(code >= 20 && code <= 29){
      icon = Icons.cloudy_snowing;
      description = "Snow rainy";
    }
     else if(code >= 30 && code <= 49){
      icon = Icons.cloudy_snowing;
      description = "Snow";
    }
    else if (code >= 50 && code  <= 59){
      icon = Icons.foggy;
      description = "Hazy";
    }
    else if (code >= 60 && code  <= 69){
      icon = Icons.cloud_rounded;
      description = "Rainy";
    }
    else if (code >= 70 && code  <= 79){
      icon = Icons.snowing;
      description = "Snowing";
    }
    else if (code >= 80 && code  <= 99){
      icon = Icons.wb_cloudy_rounded;
      description = "Pouring";
    }
    else{
      icon = Icons.tornado;
      description = "Erreur de code";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(description, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Icon(icon, size: 100, color: Colors.amber),
      ],
    );
  }


  static Widget getWeatherDescriptionWidgetToday(int code){
    IconData icon;
    String description;

    if(code >= 0 &&  code <= 1){
      icon = Icons.sunny;
      description = "Sunny";
    }
    else if(code >= 2 && code <= 3){
      icon = Icons.water_drop;
      description = "Drizzle";
    }
    else if(code >= 4 && code  <= 5){
      icon = Icons.cloud;
      description = "Cloudy";
    }
    else if(code >= 6 && code  <= 11){
      icon = Icons.foggy;
      description = "Foggy";
    }
    else if(code >= 20 && code <= 29){
      icon = Icons.cloudy_snowing;
      description = "Snow rainy";
    }
    else if(code >= 30 && code <= 49){
      icon = Icons.cloudy_snowing;
      description = "Snow";
    }
    else if (code >= 50 && code  <= 59){
      icon = Icons.foggy;
      description = "Hazy";
    }
    else if (code >= 60 && code  <= 69){
      icon = Icons.cloud_rounded;
      description = "Rainy";
    }
    else if (code >= 70 && code  <= 79){
      icon = Icons.snowing;
      description = "Snowing";
    }
    else if (code >= 80 && code  <= 99){
      icon = Icons.wb_cloudy_rounded;
      description = "Pouring";
    }
    else{
      icon = Icons.tornado;
      description = "Erreur de code";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(description, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        // SizedBox(height: 10),
        Icon(icon, size: 30),
      ],
    );
  }
}