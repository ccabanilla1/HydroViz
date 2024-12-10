import 'package:flutter/material.dart';
import 'hydro_component.dart';

// Represents a hydrological component that has been placed on the workspace
// Used to track both the type of component and where it's positioned
class PlacedComponent {
  final String? id;           // ID field for backend tracking
  final HydroComponent component;
  Offset offset;             // Non-final to allow updating position

  PlacedComponent({
    this.id,                // Optional for new components
    required this.component,
    required this.offset,
  });
}