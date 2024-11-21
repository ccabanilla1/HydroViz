import 'package:flutter/material.dart';
import '../models/hydro_component.dart';

// Represents a component that has been placed on the workspace
class PlacedComponent {
  final HydroComponent component;  // The component template
  final Offset offset;            // Position on the workspace

  PlacedComponent({
    required this.component,
    required this.offset,
  });
}

// Left sidebar widget that displays available components that can be dragged onto the workspace
class ComponentPalette extends StatelessWidget {
  final List<HydroComponent> components;              // List of available components
  final Function(HydroComponent) onComponentDragged;  // Callback when component is dragged

  const ComponentPalette({
    Key? key,
    required this.components,
    required this.onComponentDragged,
  }) : super(key: key);

  // Builds the visual representation of a component when it's being dragged
  Widget _buildComponentWidget(PlacedComponent component) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: component.component.color.withOpacity(0.2),
        border: Border.all(
          color: component.component.color,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        component.component.icon,
        color: component.component.color,
        size: 30,
      ),
    );
  }

  // Builds a list item for a component in the palette
  // isGhost determines if this is the "ghost" left behind while dragging
  Widget _buildComponentListItem(HydroComponent component, {bool isGhost = false}) {
    return Card(
      color: isGhost ? Colors.grey[100] : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: Icon(
          component.icon,
          color: component.color.withOpacity(isGhost ? 0.5 : 1.0),
        ),
        title: Text(
          component.name,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          component.description,
          style: TextStyle(
            color: isGhost ? Colors.grey : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  // Makes a component draggable and handles its various visual states
  Widget _buildDraggableComponent(HydroComponent component) {
    return Draggable<HydroComponent>(
      data: component,
      // Widget shown while dragging
      feedback: _buildComponentWidget(
        PlacedComponent(component: component, offset: Offset.zero),
      ),
      // Widget left behind in the list while dragging
      childWhenDragging: _buildComponentListItem(component, isGhost: true),
      // Normal display in the list
      child: _buildComponentListItem(component),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.white,
      child: Column(
        children: [
          // Palette title
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Components',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Scrollable list of components
          Expanded(
            child: ListView.builder(
              itemCount: components.length,
              itemBuilder: (context, index) {
                return _buildDraggableComponent(components[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}