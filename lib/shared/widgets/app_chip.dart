import 'package:flutter/material.dart';

class AppSelectableChip extends StatelessWidget {
  const AppSelectableChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.height = 48,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E3AAE) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFF1E3AAE) : const Color(0xFFD9DCE3)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF616161),
          ),
        ),
      ),
    );
  }
}
