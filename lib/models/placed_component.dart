import 'package:flutter/material.dart';
import 'hydro_component.dart';

// Represents a hydrological component that has been placed on the workspace
// Used to track both the type of component and where it's positioned
class PlacedComponent {
  final HydroComponent component;  // The type of component (well, river, etc.)
  Offset offset;                  // The x,y position on the workspace grid

  PlacedComponent({
    required this.component,
    required this.offset,
  });
}