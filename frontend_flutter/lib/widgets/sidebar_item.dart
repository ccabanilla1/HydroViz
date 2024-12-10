import 'package:flutter/material.dart';
import '../screens/landing_page/discussion.dart';

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

  SidebarTextLink({required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DiscussionPage()),
        );
      },
      child: Text(
        "- $title",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
