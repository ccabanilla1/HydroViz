import 'package:flutter/material.dart';

void main() => runApp(HydroVizApp());

class HydroVizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EDE4), // Light beige background
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: const Color(0xFF6C92BF), // Blue sidebar
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  const Text(
                    "HydroViz",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Navigation links
                  SidebarItem(
                    icon: Icons.home,
                    title: "Home",
                    onTap: () {},
                  ),
                  SidebarItem(
                    icon: Icons.topic,
                    title: "Topics",
                    onTap: () {},
                  ),
                  SidebarItem(
                    icon: Icons.trending_up,
                    title: "Trending",
                    onTap: () {},
                  ),
                  const SizedBox(height: 32),
                  // Recent Discussions
                  const Text(
                    "Recent Discussions",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SidebarTextLink(title: "Discussion Title"),
                  SidebarTextLink(title: "Discussion Title"),
                  SidebarTextLink(title: "Discussion Title"),
                  SizedBox(height: 32),
                  // Your Posts
                  const Text(
                    "Your Posts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SidebarTextLink(title: "Discussion Title"),
                  SidebarTextLink(title: "Discussion Title"),
                  SidebarTextLink(title: "Discussion Title"),
                ],
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Arrow
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {},
                        ),
                        // Search Bar
                        Container(
                          width: 300,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                "Search...",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        // User Profile
                        const Row(
                          children: [
                            Text(
                              "FirstName LastName",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Settings Section
                    const Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Settings Categories (Tabs)
                    Row(
                      children: [
                        SettingsTab(title: "Account", isActive: true),
                        SettingsTab(title: "Profile"),
                        SettingsTab(title: "Privacy"),
                        SettingsTab(title: "Preferences"),
                        SettingsTab(title: "Notifications"),
                        SettingsTab(title: "Email"),
                      ],
                    ),
                    Divider(color: Colors.grey[300], thickness: 1),
                    const SizedBox(height: 16),
                    // Account Settings Details
                    SettingsCategory(
                      title: "General",
                      items: [
                        SettingsItem(title: "Email Address"),
                        SettingsItem(title: "Phone Number"),
                        SettingsItem(title: "Password"),
                        SettingsItem(title: "Gender"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SettingsCategory(
                      title: "Account Authorization",
                      items: [
                        SettingsItem(title: "Two-Factor Authentication"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SettingsCategory(
                      title: "Advanced",
                      items: [
                        SettingsItem(
                          title: "Delete Account",
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  SidebarItem({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SidebarTextLink extends StatelessWidget {
  final String title;

  SidebarTextLink({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      "- $title",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  final String title;
  final bool isActive;

  SettingsTab({required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}

class SettingsCategory extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;

  SettingsCategory({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Column(children: items),
      ],
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final bool isDestructive;

  SettingsItem({required this.title, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isDestructive ? Colors.red : Colors.black,
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
