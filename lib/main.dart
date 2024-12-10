import 'package:flutter/material.dart';
import 'screens/login_signup/login.dart';
import 'screens/landing_page/communityhome.dart';
import 'screens/landing_page/mainscreen.dart';
import 'screens/workspace/modeling_interface.dart';

void main() {
  runApp(HydroViz());
}

class HydroViz extends StatelessWidget {
  HydroViz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HydroViz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => Login());
          case '/mainscreen':
            return MaterialPageRoute(builder: (context) => MainScreen());
          case '/modeling':
            final projectId = settings.arguments as int?;
            return MaterialPageRoute(
              builder: (context) => ModelingInterface(
                projectId: projectId ?? 1, 
              ),
            );
          case '/community':
            return MaterialPageRoute(builder: (context) => Communityhome());
          default:
            return MaterialPageRoute(builder: (context) => Login());
        }
      },
    );
  }
}