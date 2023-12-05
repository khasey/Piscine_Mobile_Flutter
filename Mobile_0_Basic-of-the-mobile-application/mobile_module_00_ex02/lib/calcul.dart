import 'package:flutter/material.dart';

class Calcul extends StatelessWidget {
  const Calcul({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double topPadding = MediaQuery.of(context).padding.top;
    double displayContainerHeight = screenHeight * 0.4;
    
    // Calcul de la hauteur disponible pour le GridView
    double gridContainerHeight = screenHeight - appBarHeight - topPadding - displayContainerHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('C A C U L A T O R',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: displayContainerHeight,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('0', style: TextStyle(fontSize: 30)),
                  Text('0', style: TextStyle(fontSize: 30)),
                ],
              ),
            ),
            SizedBox(
              height: gridContainerHeight,
              width: MediaQuery.of(context).size.width,
              child: const Calculator(),
            ),
          ],
        ),
      ),
    );
  }
}


class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final List<String> buttons = [
    '7', '8', '9', 'C', 'AC',
    '4', '5', '6', '+', '-',
    '1', '2', '3', '*', '/',
    '0', '.', '00', '=',
  ];

  @override
  Widget build(BuildContext context) {
    // Détermination de l'orientation de l'appareil
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // Ajustement du nombre de colonnes en fonction de l'orientation
    int crossAxisCount = isPortrait ? 5 : 5;

    // Taille disponible pour le GridView
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double gridHeight = isPortrait ? screenHeight * 0.6 : screenHeight * 0.8;

    return SizedBox(
      height: gridHeight,
      width: screenWidth,
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 1, // Garantir que les boutons restent carrés
        children: buttons.map((String label) {
          return ElevatedButton(
            autofocus: true,
            style: ElevatedButton.styleFrom(
              // Définition de la forme des boutons
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.grey,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            onPressed: () {
              print(label);
            },
            child: Text(
              label,
              style: TextStyle(fontSize: isPortrait ? 15 : 12, color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}