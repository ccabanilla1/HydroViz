import 'package:flutter/material.dart';

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

class Communityhome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7EDE4), // Light beige background
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Color(0xFF6C92BF), // Blue sidebar
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
                      // Add navigation functionality here
                    },
                  ),
                  SidebarItem(
                    icon: Icons.topic,
                    title: "Topics",
                    onTap: () {
                      // Add navigation functionality here
                    },
                  ),
                  SidebarItem(
                    icon: Icons.trending_up,
                    title: "Trending",
                    onTap: () {
                      // Add navigation functionality here
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
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            // Add back navigation logic here
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
                              backgroundColor:
                                  Colors.grey, // Placeholder avatar
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Create Post
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
                    // Posts
                    PostCard(),
                    PostCard(),
                    PostCard(),
                  ],
                ),
              ),
            ),
          ),

          // Updates Section
          Container(
            width: 250,
            margin: const EdgeInsets.only(
                left: 16), // Add spacing from the main content
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // White background
              borderRadius: BorderRadius.circular(16), // Rounded corners
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

class PostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 8),
              Text(
                "Discussion Title",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.green),
                  SizedBox(width: 4),
                  Text("321 Likes"),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.comment, color: Colors.grey),
                  SizedBox(width: 4),
                  Text("20 comments"),
                ],
              ),
              Icon(Icons.share, color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}

class UpdateNote extends StatelessWidget {
  final String title;
  final String description;

  UpdateNote({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
