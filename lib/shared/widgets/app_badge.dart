import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.title, this.color = Colors.blue});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(.15), borderRadius: BorderRadius.circular(20)),
      child: Text(title, style: TextStyle(color: color)),
    );
  }
}
