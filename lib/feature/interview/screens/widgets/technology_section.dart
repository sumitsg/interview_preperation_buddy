import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_chip.dart';

class TechnologySection extends StatelessWidget {
  const TechnologySection({
    super.key,
    required this.selectedTechnology,
    required this.technologies,
    required this.onTechnologySelected,
  });

  final String? selectedTechnology;
  final List<String> technologies;
  final ValueChanged<String> onTechnologySelected;

  @override
  Widget build(BuildContext context) {
    // technologies.sort((a, b) => a.length.compareTo(b.length));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Technology Stack', style: AppTextStyles.sectionTitle),

        const SizedBox(height: 16),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: technologies.map((technology) {
            return AppSelectableChip(
              title: technology,
              isSelected: selectedTechnology == technology,
              onTap: () => onTechnologySelected(technology),
            );
          }).toList(),
        ),
      ],
    );
  }
}
