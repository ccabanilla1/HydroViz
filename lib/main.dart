import 'package:flutter/material.dart';
import 'screens/modeling_interface.dart';

// Entry point for the HydroViz application
void main() {
  runApp(const HydroViz());
}

// Root widget of the HydroViz application
class HydroViz extends StatelessWidget {
  const HydroViz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Removes the debug banner from the top right
      title: 'HydroViz',
      theme: ThemeData(
        primarySwatch: Colors.blue,       // Sets the main color scheme for the app
        scaffoldBackgroundColor: Colors.grey[200],  // Light grey background for all screens
      ),
      home: const ModelingInterface(),    // Sets the modeling interface as the main screen
    );
  }
}