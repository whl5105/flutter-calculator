import 'package:flutter/material.dart';
// import 'package:flutter_calculator/screens/home_screen.dart';
// import 'package:flutter_calculator/screens/home_calculator.dart';
import 'package:flutter_calculator/screens/calculator.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Calculator(),
    );
  }
}
