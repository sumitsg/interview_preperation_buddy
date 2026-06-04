import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_chip.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_text.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({
    super.key,
    required this.selectedExperience,
    required this.onExperienceSelected,
    required this.experiences,
  });

  final String? selectedExperience;
  final ValueChanged<String> onExperienceSelected;
  final List<String> experiences;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Years of Experience', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: experiences.map((experience) {
            final isSelected = selectedExperience == experience;

            return AppSelectableChip(
              title: experience,
              isSelected: isSelected,
              onTap: () => onExperienceSelected(experience),
            );
          }).toList(),
        ),
      ],
    );
  }
}
