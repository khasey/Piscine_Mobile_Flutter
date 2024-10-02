import 'package:flutter/material.dart';
import 'package:mobile_weather_app/currently.dart';
import 'package:mobile_weather_app/today.dart';
import 'package:mobile_weather_app/weekly.dart';

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
            onPressed: () {
              setState(() {
                cityName = 'Geolocalisation';
              });
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
            icon: Icon(Icons.calendar_today),
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
