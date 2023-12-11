import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_v2_proj/currently.dart';
import 'package:weather_app_v2_proj/today.dart';
import 'package:weather_app_v2_proj/weekly.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    final response = await http.get(Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5&language=en&format=json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data.containsKey('results')) {
        List<dynamic> results = data['results'];
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
        return [];
      }
    } else {
      throw Exception('Failed to load cities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              selectionFull = selectedCity+ ", " + selectedRegion + ", " + selectedCountry;
              
            });
          },
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            textEditingController.text = selectionFull;
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
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
                child: Container(
                  width: 300, // Ajustez la largeur si nécessaire
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(option['label']),
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
                setState(() {
                  selectedCity = "";
                  selectedRegion = "";
                  selectedCountry = "";
                  selectedLatitude = position.latitude;
                  selectedLongitude = position.longitude;
                  isGeoLocationEnabled = true;
                });
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        children: [
          Currently(
            cityName: selectionFull,
            // region: selectedRegion,
            // country: selectedCountry,
            latitude: selectedLatitude,
            longitude: selectedLongitude,
            isGeoLocationEnabled: isGeoLocationEnabled
          ),
          Today(
            cityName: selectionFull,
            latitude: selectedLatitude,
            longitude: selectedLongitude,
            isGeoLocationEnabled: isGeoLocationEnabled
          ),
          Weekly(
            cityName: selectionFull,
            latitude: selectedLatitude,
            longitude: selectedLongitude,
            isGeoLocationEnabled: isGeoLocationEnabled
          ),
        ],
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

//avoir la localisation de l'utilisateur et l'afficher dans le champ de recherche

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
