import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calcul extends StatefulWidget {
  const Calcul({Key? key}) : super(key: key);

  @override
  _CalculState createState() => _CalculState();
}

class _CalculState extends State<Calcul> {
  String currentOperation = "";
  String result = "";

  void onButtonPressed(String label) {
    setState(() {
      if (label == 'C') {
        currentOperation = '';
        result = '';
      } else if (label == 'AC') {
        if (currentOperation.isNotEmpty) {
          currentOperation = currentOperation.substring(0, currentOperation.length - 1);
        }
      } else if (label == '=') {
        try {
        Parser p = Parser();
        Expression exp = p.parse(currentOperation);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        result = eval.toString();
      } catch (e) {
        result = 'Error';
      }
        // Ici, vous pouvez utiliser une bibliothèque pour évaluer l'expression mathématique
      //  result = evaluate(currentOperation);
      } else {
        currentOperation += label;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double topPadding = MediaQuery.of(context).padding.top;
    double displayContainerHeight = screenHeight * 0.3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('C A C U L A T O R',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 4, 29, 49),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: displayContainerHeight,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(currentOperation, style: const TextStyle(fontSize: 30)),
                Text(result, style: const TextStyle(fontSize: 30)),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          Flexible(
  child: Calculator(
    onButtonPressed: onButtonPressed,
  ),
),

        ],
      ),
    );
  }
}

class Calculator extends StatelessWidget {
  final void Function(String) onButtonPressed;

  Calculator({Key? key, required this.onButtonPressed}) : super(key: key);

  final List<String> buttons = [
    '7', '8', '9', 'C', 'AC',
    '4', '5', '6', '+', '-',
    '1', '2', '3', '*', '/',
    '0', '.', '00', '=',
  ];

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    int crossAxisCount = isPortrait ? 5 : 5;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double gridHeight = isPortrait ? screenHeight * 0.6 : screenHeight * 0.8;
    double aspect = isPortrait ? screenWidth / gridHeight : screenWidth / gridHeight + 1;

    return Container(
      color: Color.fromARGB(255, 4, 29, 49),
      alignment: Alignment.bottomRight,
      height: gridHeight,
      width: screenWidth,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: aspect,
        children: buttons.map((String label) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: const BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid),
              ),
            ),
            onPressed: () => onButtonPressed(label),
            child: Text(label, style: TextStyle(fontSize: isPortrait ? 15 : 12, color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }
}
