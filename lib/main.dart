import 'package:flutter/material.dart';

// Entry point of the application
void main() {
  runApp(const HydroViz());
}

// Root widget of the application
// StatelessWidget because the app-wide configuration doesn't change
class HydroViz extends StatelessWidget {
  const HydroViz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HydroViz',
      // Define the app-wide theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200], // Light grey background
      ),
      home: const ModelingInterface(), // Set the main screen
    );
  }
}

// Main interface for the modeling application
// StatefulWidget because it needs to maintain the state of placed components
class ModelingInterface extends StatefulWidget {
  const ModelingInterface({Key? key}) : super(key: key);

  @override
  State<ModelingInterface> createState() => _ModelingInterfaceState();
}

class _ModelingInterfaceState extends State<ModelingInterface> {
  // List to store components that have been placed on the grid
  final List<PlacedComponent> _placedComponents = [];
  
  // Define the available component types that can be dragged onto the grid
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
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title and actions
      appBar: AppBar(
        title: const Text('HydroViz - Hydrological Modeling'),
        actions: [
          // Clear all button
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _placedComponents.clear(); // Remove all placed components
              });
            },
            tooltip: 'Clear all components',
          ),
        ],
      ),
      // Main body with component palette and modeling canvas
      body: Row(
        children: [
          // Left sidebar: Component palette
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                // Palette header
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
                // Scrollable list of available components
                Expanded(
                  child: ListView.builder(
                    itemCount: _components.length,
                    itemBuilder: (context, index) {
                      return _buildDraggableComponent(_components[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Right side: Modeling canvas
          Expanded(
            child: Stack(
              children: [
                // Background grid
                CustomPaint(
                  painter: GridPainter(),
                  child: Container(),
                ),
                // Area that accepts dropped components
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
                              // Allow components to be moved after placement
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
                  // Handle component dropping
                  onAcceptWithDetails: (details) {
                    setState(() {
                      _placedComponents.add(
                        PlacedComponent(
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
    );
  }

  // Create a draggable component for the palette
  Widget _buildDraggableComponent(HydroComponent component) {
    return Draggable<HydroComponent>(
      data: component, // Data to be passed when dragged
      feedback: _buildComponentWidget( // Widget shown while dragging
        PlacedComponent(component: component, offset: Offset.zero),
      ),
      childWhenDragging: _buildComponentListItem(component, isGhost: true), // Shown in original position while dragging
      child: _buildComponentListItem(component), // Normal display
    );
  }

  // Create a list item for the component palette
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
          style: TextStyle(
            color: isGhost ? Colors.grey : Colors.black,
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

  // Create the visual representation of a placed component
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
}

// Custom painter for drawing the background grid
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1.0;

    const gridSize = 40.0; // Size of grid cells

    // Draw vertical lines
    for (double i = 0; i <= size.width; i += gridSize) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double i = 0; i <= size.height; i += gridSize) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Data class for defining component types
class HydroComponent {
  final String name;        // Display name
  final IconData icon;      // Icon to display
  final Color color;        // Color theme
  final String description; // Component description

  HydroComponent({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}

// Data class for tracking placed components
class PlacedComponent {
  final HydroComponent component; // The type of component
  Offset offset;                  // Position on the grid

  PlacedComponent({
    required this.component,
    required this.offset,
  });
}