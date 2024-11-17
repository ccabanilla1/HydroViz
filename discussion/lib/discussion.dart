import 'package:flutter/material.dart';

void main() => runApp(HydroVizApp());

class HydroVizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
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
                    // First Discussion Post with Comments and Input
                    PostCardWithComments(),
                    const SizedBox(height: 16),
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

class PostCardWithComments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
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
          const SizedBox(height: 8),
          // Post Content
          const Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting "
            "industry. Lorem Ipsum has been the industry's standard dummy "
            "text ever since the 1500s, when an unknown printer took a galley "
            "of type and scrambled it to make a type specimen book.",
          ),
          const SizedBox(height: 8),
          // Likes, Comments, and Share
          const Row(
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
                  Text("30 Comments"),
                ],
              ),
              Icon(Icons.share, color: Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          // Comment Threads
          CommentWidget(
            author: "FirstName LastName",
            text: "This is the first comment.",
            replies: [
              CommentWidget(
                author: "FirstName LastName",
                text: "This is a reply to the first comment.",
              ),
            ],
          ),
          CommentWidget(
            author: "FirstName LastName",
            text: "This is another comment.",
            replies: [],
          ),
          const SizedBox(height: 16),
          // Add New Comment
          Row(
            children: [
              const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final String author;
  final String text;
  final List<CommentWidget> replies;

  CommentWidget(
      {required this.author, required this.text, this.replies = const []});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                author,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(text),
          for (var reply in replies) reply,
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
