import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_text.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_textfield.dart';

class FocusAreaSection extends StatelessWidget {
  const FocusAreaSection({super.key, required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Specific Focus Areas (Optional)', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 16),
        AppTextField(
          controller: controller,

          hintText: 'e.g., concurrency, load balancing, React hooks...',
          maxLines: 2,
          maxLength: 100,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
