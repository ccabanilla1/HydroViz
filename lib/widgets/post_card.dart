import 'package:flutter/material.dart';
import 'package:homepage/screens/discussion.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String description;
  final int likes;
  final int comments;

  const PostCard({
    Key? key,
    required this.title,
    required this.description,
    required this.likes,
    required this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to discussion page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DiscussionPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.green),
                    const SizedBox(width: 4),
                    Text("$likes Likes"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.comment, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text("$comments Comments"),
                  ],
                ),
                const Icon(Icons.share, color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
