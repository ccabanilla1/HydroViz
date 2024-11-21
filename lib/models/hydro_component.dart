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

// Represents a component that has been placed on the workspace
// Keeps track of both the component type and its position
class PlacedComponent {
  final HydroComponent component;  // Reference to the component template
  Offset offset;                  // Current position on the workspace

  PlacedComponent({
    required this.component,
    required this.offset,
  });
}