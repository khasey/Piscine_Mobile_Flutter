import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_v2_proj/currently.dart';
import 'package:weather_app_v2_proj/today.dart';
import 'package:weather_app_v2_proj/weekly.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentPageIndex = 0;
  bool isGeoLocationEnabled = false;
  String cityName = '';
  final TextEditingController cityController = TextEditingController();

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: kToolbarHeight - 10, // Réduire la hauteur pour l'alignement
            child: TextField(
              controller: cityController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search a Town...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) => setState(() {
                cityName = value;
              }),
            ),
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () async {
              try {
                Position position = await _determinePosition();
                setState(() {
                  // Mise à jour de l'interface utilisateur avec la latitude et la longitude
                  cityName = "${position.latitude}, ${position.longitude}";
                  isGeoLocationEnabled = true;
                });
              } catch (e) {
                setState(() {
                  cityName = 'error';
                });
                
                // Gérer l'erreur, par exemple en affichant une boîte de dialogue
                print(e); // Pour le débogage
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
              cityName: cityName, isGeoLocationEnabled: isGeoLocationEnabled),
          Today(cityName: cityName, isGeoLocationEnabled: isGeoLocationEnabled),
          Weekly(
              cityName: cityName, isGeoLocationEnabled: isGeoLocationEnabled),
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
