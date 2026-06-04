import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_chip.dart';

class ExperienceSelector extends StatelessWidget {
  const ExperienceSelector({
    super.key,
    required this.experiences,
    required this.selectedExperience,
    required this.onSelected,
  });

  final List<String> experiences;
  final String? selectedExperience;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: experiences.map((item) {
        return AppSelectableChip(title: item, isSelected: selectedExperience == item, onTap: () => onSelected(item));
      }).toList(),
    );
  }
}
