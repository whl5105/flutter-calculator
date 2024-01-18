import 'package:flutter/material.dart';
import 'package:flutter_calculator/screens/calculator.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CalculatorScreens(),
    );
  }
}
