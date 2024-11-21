import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydroviz/screens/modeling_interface.dart';

void main() {
  testWidgets('ModelingInterface basic functionality test', (WidgetTester tester) async {
    // Build the modeling interface and trigger a frame
    await tester.pumpWidget(
      const MaterialApp(
        home: ModelingInterface(),
      ),
    );

    // Test for the presence of key components
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('HydroViz - Hydrological Modeling'), findsOneWidget);
    
    // Test for initial components count
    expect(find.text('Components: 0'), findsOneWidget);
    
    // Test for clear button
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    
    // Test for component list button
    expect(find.byIcon(Icons.list), findsOneWidget);
  });
}