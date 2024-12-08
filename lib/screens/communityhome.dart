import 'package:flutter/material.dart';
import '../main.dart';
import 'discussion.dart';
import 'error404.dart';
import 'settings_community.dart';
import '../widgets/post_card.dart';

void main() => runApp(HydroVizApp());

class HydroVizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Communityhome(),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  final TextStyle? textStyle;

  const SidebarItem({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor = Colors.white,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Sidebar item: $title",
      button: true,
      child: InkWell(
        onTap: onTap ?? () {}, // Default to no-op if onTap is null
        splashColor: Colors.grey.withOpacity(0.3), // Ripple effect
        highlightColor: Colors.grey.withOpacity(0.1), // Pressed color
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 16),
              Text(title, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}

class SidebarTextLink extends StatelessWidget {
  final String title;
  final VoidCallback? onTap; // Optional custom action

  const SidebarTextLink({Key? key, required this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DiscussionPage()),
            );
          },
      splashColor: Colors.grey.withOpacity(0.3), // Add ripple effect
      child: Text(
        "- $title",
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

class Communityhome extends StatelessWidget {
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Communityhome()),
                      );
                    },
                  ),
                  SidebarItem(
                    icon: Icons.topic,
                    title: "Topics",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Error404()),
                      );
                    },
                  ),
                  SidebarItem(
                    icon: Icons.trending_up,
                    title: "Trending",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Error404()),
                      );
                    },
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
                  const SizedBox(height: 16),
                  SidebarTextLink(title: "Discussion Title"),
                  SidebarTextLink(title: "Discussion Title"),
                  SidebarTextLink(title: "Discussion Title"),
                  const SizedBox(height: 32),
                  // Your Posts
                  const Text(
                    "Your Posts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()),
                            );
                          },
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
                        // User Profile with Dropdown
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: const Row(
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
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "settings",
                                child: Row(
                                  children: [
                                    Icon(Icons.settings, size: 18),
                                    SizedBox(width: 8),
                                    Text("Settings"),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: "logout",
                                child: Row(
                                  children: [
                                    Icon(Icons.logout, size: 18),
                                    SizedBox(width: 8),
                                    Text("Logout"),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == "settings") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CSettingsPage()),
                                );
                              } else if (value == "logout") {
                                // Add logout logic
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Create Post Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Create Post",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.photo),
                                label: const Text("Gallery"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB7866E),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text("Post"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6A994E),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Posts Section
                    const PostCard(
                      title: "Discussion Title 1",
                      description: "Lorem Ipsum is simply dummy text.",
                      likes: 321,
                      comments: 20,
                    ),
                    const PostCard(
                      title: "Discussion Title 2",
                      description: "Lorem Ipsum is industry dummy text.",
                      likes: 150,
                      comments: 12,
                    ),
                    const PostCard(
                      title: "Discussion Title 3",
                      description: "Dummy text used in the printing industry.",
                      likes: 200,
                      comments: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Updates Section
          Container(
            width: 250,
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "HydroViz Update Notes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                UpdateNote(
                  title: "Update 1",
                  description: "Description for the first update.",
                ),
                UpdateNote(
                  title: "Update 2",
                  description: "Description for the second update.",
                ),
                UpdateNote(
                  title: "Update 3",
                  description: "Description for the third update.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
