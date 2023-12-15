import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_final_proj/currently.dart';
import 'package:weather_final_proj/today.dart';
import 'package:weather_final_proj/weekly.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentPageIndex = 0;
  bool isGeoLocationEnabled = false;
  String selectedCity = '';
  String selectedRegion = '';
  String selectedCountry = '';
  double? selectedLatitude;
  double? selectedLongitude;
  String selectionFull = '';
  final PageController pageController = PageController();

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> getLocationDetails(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'http://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        selectedCity = data['address']['village'] ??
            data['address']['town'] ??
            data['address']['city'] ??
            '';
        selectedRegion = data['address']['state'] ?? '';
        selectedCountry = data['address']['country'] ?? '';
        selectionFull = "$selectedCity, $selectedRegion, $selectedCountry";
      });
    } else {
      showError('Failed to fetch location details');
      // Gérer l'erreur ici
    }
  }

  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    final response = await http.get(Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5&language=en&format=json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data.containsKey('results')) {
        List<dynamic> results = data['results'];
        if (results.isEmpty) {
          // Gestion de la ville inexistante
          showError("City name not valid.");
          return [];
        }
        return results.map((item) {
          String name = item['name'];
          String region = item.containsKey('admin1') ? item['admin1'] : '';
          String country = item.containsKey('country') ? item['country'] : '';
          double latitude = item['latitude'];
          double longitude = item['longitude'];
          return {
            "label": "$name, $region, $country",
            "name": name,
            "region": region,
            "country": country,
            "latitude": latitude,
            "longitude": longitude
          };
        }).toList();
      } else {
        // showError("Connection to the API failed.");
        return [];
      }
    } else {
      showError("Connection to the API failed.");
      throw Exception('Failed to load cities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(243, 236, 250, 1),
        title: Autocomplete<Map<String, dynamic>>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text == '') {
              return const Iterable<Map<String, dynamic>>.empty();
            }
            return searchCities(textEditingValue.text);
          },
          onSelected: (Map<String, dynamic> selection) {
            setState(() {
              selectedCity = selection['name'];
              selectedRegion = selection['region'];
              selectedCountry = selection['country'];
              selectedLatitude = selection['latitude'];
              selectedLongitude = selection['longitude'];
              selectionFull =
                  "$selectedCity, $selectedRegion, $selectedCountry";
            });
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            textEditingController.text = selectionFull;
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              cursorColor: Colors.amber,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search a Town...',
                border: InputBorder.none,
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  width: 350, // Ajustez la largeur si nécessaire
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        leading: const Icon(Icons.home_filled),
                        iconColor: Colors.black,
                        title: Text(option['label'],
                            style: const TextStyle(fontSize: 16)),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () async {
              try {
                Position position = await _determinePosition();
                await getLocationDetails(position.latitude, position.longitude);
                setState(() {
                  selectedCity = "";
                  selectedRegion = "";
                  selectedCountry = "";
                  selectedLatitude = position.latitude;
                  selectedLongitude = position.longitude;
                  isGeoLocationEnabled = true;
                });
              } catch (e) {
                // ignore: avoid_print
                print(e);
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/back.jpg"), // Assurez-vous que ce chemin est correct
            fit: BoxFit.cover,
          ),
        ),
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          children: [
            Currently(
              cityName: selectionFull,
              latitude: selectedLatitude,
              longitude: selectedLongitude,
              isGeoLocationEnabled: isGeoLocationEnabled,
            ),
            Today(
              cityName: selectionFull,
              latitude: selectedLatitude,
              longitude: selectedLongitude,
              isGeoLocationEnabled: isGeoLocationEnabled,
            ),
            Weekly(
              cityName: selectionFull,
              latitude: selectedLatitude,
              longitude: selectedLongitude,
              isGeoLocationEnabled: isGeoLocationEnabled,
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.sunny_snowing),
            icon: Icon(Icons.sunny),
            label: 'Currently',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_today),
            icon: Badge(child: Icon(Icons.calendar_today_outlined)),
            label: 'Today',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_view_week),
            icon: Icon(Icons.calendar_view_day),
            label: 'Weekly',
          ),
        ],
      ),
    );
  }
}
//avoir la localisation de l'utilisateur et l'afficher dans le champ de recherche

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}
