import 'package:flutter/material.dart';

// CustomPainter that draws a grid pattern for the workspace background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Set up the paint style for grid lines
    final paint = Paint()
      ..color = Colors.grey[300]!  // Light grey color for grid
      ..strokeWidth = 1.0;         // Thin lines for grid

    const gridSize = 40.0;  // Size of each grid cell

    // Draw vertical grid lines
    for (double i = 0; i <= size.width; i += gridSize) {
      canvas.drawLine(
        Offset(i, 0),             // Start from top
        Offset(i, size.height),   // Draw to bottom
        paint,
      );
    }

    // Draw horizontal grid lines
    for (double i = 0; i <= size.height; i += gridSize) {
      canvas.drawLine(
        Offset(0, i),            // Start from left
        Offset(size.width, i),   // Draw to right
        paint,
      );
    }
  }

  @override
  // Grid doesn't change, so no need to repaint
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}