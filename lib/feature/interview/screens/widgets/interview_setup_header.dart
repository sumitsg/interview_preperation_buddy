import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/app/themes/app_colors.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';

class InterviewSetupHeader extends StatelessWidget {
  const InterviewSetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.neutralLight)),
      ),
      child: Row(
        children: [
          Text('InterviewPro', style: AppTextStyles.headline3.copyWith(color: AppColors.primary)),

          const Spacer(),

          if (isMobile)
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined))
          else
            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.logout_outlined), label: const Text('Exit')),
        ],
      ),
    );
  }
}
