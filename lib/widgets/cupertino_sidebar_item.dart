import 'package:flutter/cupertino.dart';

class SidebarItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;

  const SidebarItem({
    required this.title,
    this.subtitle,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8, left: 24),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }
}
