import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_chip.dart';

class TechnologySelector extends StatelessWidget {
  const TechnologySelector({
    super.key,
    required this.technologies,
    required this.selectedTechnology,
    required this.onSelected,
  });

  final List<String> technologies;
  final String? selectedTechnology;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    technologies.sort((a, b) => a.length.compareTo(b.length));
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: technologies.map((tech) {
        return AppSelectableChip(title: tech, isSelected: selectedTechnology == tech, onTap: () {});
      }).toList(),
    );
  }
}
