import 'package:flutter/material.dart';

// Defines a template for hydro components that can be placed in the workspace
// (like wells, rivers, recharge zones, etc.)
class HydroComponent {
  final String name;         // Name of the component (e.g., "Well", "River")
  final IconData icon;       // Icon to display in the component palette
  final Color color;         // Color used to display the component
  final String description;  // Brief description of what the component does

  HydroComponent({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}

