import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Blue Bar
          Container(
            color: Color(0xFF93C6E0), // Light blue color
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/logo.png', // Replace with your logo path
                      height: 40,
                      width: 40,
                    ),
                    SizedBox(width: 16),
                    Text(
                      'HydroViz',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                // Search Bar
                Container(
                  width: 400,
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.black54),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Sidebar
                Container(
                  width: 80,
                  color: Color(0xFF93C6E0), // Light blue color
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.dashboard,
                                  size: 30, color: Colors.black),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.people,
                                  size: 30, color: Colors.black),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.search,
                                  size: 30, color: Colors.black),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.settings,
                                  size: 30, color: Colors.black),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/profile.png'), // Replace with profile image
                          radius: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                // Main Content (Adjusted for Middle-Left Placement)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, top: 50), // Add padding to position content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Start Section
                        Text(
                          'Start',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.add_circle, color: Colors.green),
                              label: Text(
                                'New Project...',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16),
                              ),
                            ),
                            SizedBox(width: 16),
                            TextButton.icon(
                              onPressed: () {},
                              icon:
                                  Icon(Icons.folder_open, color: Colors.green),
                              label: Text(
                                'Open...',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        // Recent Section
                        Text(
                          'Recent',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Project Example',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.green)),
                            Text('Project Example',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.green)),
                            Text('Project Example',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Walkthroughs Section (Right Side)
                Container(
                  width: 300,
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Walkthroughs',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      walkthroughTile(),
                      walkthroughTile(),
                      walkthroughTile(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget walkthroughTile() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get Started with HydroViz',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Learn the Basics and start your project!',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
