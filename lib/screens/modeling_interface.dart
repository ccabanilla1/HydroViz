import 'package:flutter/material.dart';
import '../models/hydro_component.dart';
import '../models/placed_component.dart' as pc;  // Changed prefix to shorter name
import '../widgets/component_palette.dart';
import '../widgets/grid_painter.dart';

// Main screen for the hydrological modeling interface
class ModelingInterface extends StatefulWidget {
  const ModelingInterface({Key? key}) : super(key: key);

  @override
  State<ModelingInterface> createState() => _ModelingInterfaceState();
}

class _ModelingInterfaceState extends State<ModelingInterface> {
  // List to track all components placed on the workspace
  final List<pc.PlacedComponent> _placedComponents = [];
  
  // Available component types that can be dragged onto the workspace
  final List<HydroComponent> _components = [
    HydroComponent(
      name: 'Well',
      icon: Icons.radio_button_checked,
      color: Colors.blue,
      description: 'Pumping or injection well',
    ),
    HydroComponent(
      name: 'River',
      icon: Icons.water,
      color: Colors.lightBlue,
      description: 'River boundary condition',
    ),
    HydroComponent(
      name: 'Recharge',
      icon: Icons.arrow_downward,
      color: Colors.green,
      description: 'Groundwater recharge zone',
    ),
    HydroComponent(
      name: 'Boundary',
      icon: Icons.border_all,
      color: Colors.red,
      description: 'No-flow boundary',
    ),
  ];

  // Builds the visual representation of a placed component
  Widget _buildComponentWidget(pc.PlacedComponent component) {
    return Stack(
      children: [
        Container(
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
        ),
        // Show component coordinates below the icon
        Positioned(
          bottom: -20,
          child: Text(
            '(${component.offset.dx.toStringAsFixed(1)}, ${component.offset.dy.toStringAsFixed(1)})',
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HydroViz - Hydrological Modeling'),
        actions: [
          // Display component count in app bar
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Components: ${_placedComponents.length}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          // Clear all components button
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _placedComponents.clear();
              });
            },
            tooltip: 'Clear all components',
          ),
        ],
      ),
      body: Row(
        children: [
          // Left sidebar with draggable components
          ComponentPalette(
            components: _components,
            onComponentDragged: (component) {
              // Handle component dragging
            },
          ),
          // Main workspace area
          Expanded(
            child: Stack(
              children: [
                // Grid background
                CustomPaint(
                  painter: GridPainter(),
                  child: Container(),
                ),
                // Drop target for new components
                DragTarget<HydroComponent>(
                  builder: (context, candidateData, rejectedData) {
                    return Stack(
                      children: [
                        // Display all placed components
                        ..._placedComponents.map((component) {
                          return Positioned(
                            left: component.offset.dx,
                            top: component.offset.dy,
                            child: GestureDetector(
                              // Allow components to be dragged around
                              onPanUpdate: (details) {
                                setState(() {
                                  component.offset += details.delta;
                                });
                              },
                              child: _buildComponentWidget(component),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                  // Handle dropping new components onto the workspace
                  onAcceptWithDetails: (details) {
                    setState(() {
                      _placedComponents.add(
                        pc.PlacedComponent(
                          component: details.data,
                          offset: details.offset,
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // Button to show list of placed components
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.list),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _placedComponents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final component = _placedComponents[index];
                    // List tile for each placed component
                    return ListTile(
                      leading: Icon(component.component.icon),
                      title: Text(component.component.name),
                      subtitle: Text(
                        'Position: (${component.offset.dx.toStringAsFixed(1)}, ${component.offset.dy.toStringAsFixed(1)})',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _placedComponents.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}