import 'package:flutter/material.dart';
import 'mainscreen.dart';
import 'error404.dart';
import 'settings_community.dart';
import '../../../widgets/post_card.dart';
import 'package:hydroviz/widgets/sidebar_item.dart';
import 'package:hydroviz/services/post_service.dart';
import '../../../widgets/updatenote.dart';

class Communityhome extends StatefulWidget {
  @override
  _CommunityhomeState createState() => _CommunityhomeState();
}

class _CommunityhomeState extends State<Communityhome> {
  late Future<List<dynamic>> _posts; // Future to fetch posts
  final TextEditingController _postController =
      TextEditingController(); // Controller for post creation

  @override
  void initState() {
    super.initState();
    _posts = fetchPosts(); // Fetch posts from the Django backend
  }

  // Function to handle post creation
  Future<void> _createPost(String content) async {
    try {
      await createPost(
          "Anonymous", content); // Create post with title 'Anonymous'
      setState(() {
        _posts = fetchPosts(); // Refresh posts after creation
      });
      _postController.clear(); // Clear the text field
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EDE4), // Light beige background
      body: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the top
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
                  const Text(
                    "HydroViz",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SidebarItem(
                    icon: Icons.home,
                    title: "Home",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Communityhome()),
                    ),
                  ),
                  SidebarItem(
                    icon: Icons.topic,
                    title: "Topics",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Error404()),
                    ),
                  ),
                  SidebarItem(
                    icon: Icons.trending_up,
                    title: "Trending",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Error404()),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Recent Discussions",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SidebarTextLink(title: "Discussion Title 1"),
                  SidebarTextLink(title: "Discussion Title 2"),
                  SidebarTextLink(title: "Discussion Title 3"),
                  const SizedBox(height: 32),
                  const Text(
                    "Your Posts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SidebarTextLink(title: "Post Title 1"),
                  SidebarTextLink(title: "Post Title 2"),
                  SidebarTextLink(title: "Post Title 3"),
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
                            controller: _postController,
                            decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              final content = _postController.text.trim();
                              if (content.isNotEmpty) {
                                _createPost(content);
                              }
                            },
                            child: const Text("Post"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A994E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Posts Section
                    FutureBuilder<List<dynamic>>(
                      future: _posts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No posts available.'));
                        } else {
                          final posts = snapshot.data!;
                          return Column(
                            children: posts.map((post) {
                              return PostCard(
                                title: post['title'],
                                description: post['content'],
                                likes: 0,
                                comments: 0,
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Update Notes Section (on the right)
          Container(
            width: 300,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
