import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../models/hydro_component.dart';
import '../models/placed_component.dart' as pc;  // Using prefix to avoid naming conflicts
import '../services/api_service.dart';
import '../widgets/component_palette.dart';
import '../widgets/grid_painter.dart';

// Main screen for the hydrological modeling interface
class ModelingInterface extends StatefulWidget {
  const ModelingInterface({Key? key}) : super(key: key);

  @override
  State<ModelingInterface> createState() => _ModelingInterfaceState();
}

class _ModelingInterfaceState extends State<ModelingInterface> {
  // Services and utilities
  final ApiService _apiService = ApiService();
  final _logger = Logger('ModelingInterface');
  
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

  @override
  void initState() {
    super.initState();
    _loadComponents();  // Load existing components when screen initializes
  }

  // Fetches existing components from the backend
  Future<void> _loadComponents() async {
    try {
      final components = await _apiService.getComponents();
      setState(() {
        _placedComponents.clear();
        for (var comp in components) {
          _placedComponents.add(pc.PlacedComponent(
            component: _findComponentByName(comp['type']),
            offset: Offset(comp['location_x'].toDouble(), comp['location_y'].toDouble()),
            id: comp['id'].toString()
          ));
        }
      });
    } catch (e) {
      _logger.severe('Failed to load components: $e');
      _showErrorSnackBar('Failed to load components');
    }
  }

  // Helper method to find component template by name
  HydroComponent _findComponentByName(String name) {
    return _components.firstWhere(
      (c) => c.name == name,
      orElse: () => _components.first,  // Fallback to first component if not found
    );
  }

  // Shows error message to user
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Updates component position in backend after drag
  Future<void> _updateComponentPosition(pc.PlacedComponent component) async {
    try {
      await _apiService.updateComponentPosition(
        component.id ?? '',  // ID might be null for new components
        {
          'x': component.offset.dx,
          'y': component.offset.dy,
        },
      );
    } catch (e) {
      _logger.warning('Failed to update component position: $e');
      _showErrorSnackBar('Failed to update component position');
    }
  }

// Deletes a single component
Future<void> _deleteComponent(int index) async {
    final component = _placedComponents[index];
    try {
      final id = component.id;  // Store the ID
      if (id != null) {        // Check if ID exists
        await _apiService.deleteComponent(id);  // Pass the String ID
      }
      setState(() {
        _placedComponents.removeAt(index);
      });
    } catch (e) {
      _logger.severe('Failed to delete component: $e');
      _showErrorSnackBar('Failed to delete component');
    }
}

// Clears all components
Future<void> _clearAllComponents() async {
    try {
      for (var component in _placedComponents) {
        final id = component.id;  // Store the ID
        if (id != null) {        // Check if ID exists
          await _apiService.deleteComponent(id);  // Pass the String ID
        }
      }
      setState(() {
        _placedComponents.clear();
      });
    } catch (e) {
      _logger.severe('Failed to clear components: $e');
      _showErrorSnackBar('Failed to clear all components');
    }
}

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
            onPressed: _clearAllComponents,
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
                              // Update backend when drag ends
                              onPanEnd: (_) => _updateComponentPosition(component),
                              child: _buildComponentWidget(component),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                  // Handle dropping new components onto the workspace
                  onAcceptWithDetails: (details) async {
                    try {
                      _logger.info('Drag details - offset: ${details.offset}');  // Debug print
                      
                      final newComponent = {
                        'type': details.data.name.toUpperCase(),
                        'location_x': details.offset.dx.toDouble(),  // Explicitly convert to double
                        'location_y': details.offset.dy.toDouble(),  // Explicitly convert to double
                        'properties': {},
                        'project': 1
                      };
                      
                      _logger.info('Component data being sent: $newComponent');  // Debug print
                      
                      final savedComponent = await _apiService.saveComponent(newComponent);
                      
                      setState(() {
                        _placedComponents.add(
                          pc.PlacedComponent(
                            id: savedComponent['id'].toString(),
                            component: details.data,
                            offset: details.offset,
                          ),
                        );
                      });
                    } catch (e) {
                      _logger.severe('Failed to save component: $e');
                      _showErrorSnackBar('Failed to save component');
                    }
                  }
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
                    return ListTile(
                      leading: Icon(component.component.icon),
                      title: Text(component.component.name),
                      subtitle: Text(
                        'Position: (${component.offset.dx.toStringAsFixed(1)}, ${component.offset.dy.toStringAsFixed(1)})',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Cache the context before the async gap
                          final currentContext = context;
                           _deleteComponent(index).then((_) {
                            if (currentContext.mounted) {
                              Navigator.pop(currentContext);
                            }
                          });
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