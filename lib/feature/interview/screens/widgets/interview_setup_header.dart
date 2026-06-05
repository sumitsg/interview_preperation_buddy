import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interview_preperation_buddy/app/themes/app_colors.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_button.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_text.dart';

class InterviewSetupHeader extends StatelessWidget {
  const InterviewSetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.neutralLight)),
      ),
      child: Row(
        children: [
          AppText('InterviewPro', style: AppTextStyles.headline3.copyWith(color: AppColors.primary)),

          const Spacer(),

          TextButton.icon(
            onPressed: () {
              showExitDialog(context);
            },
            icon: const Icon(Icons.logout_outlined),
            label: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  Future<void> showExitDialog(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Exit Interview'),
        content: const Text('Are you sure you want to close the application?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Exit')),
        ],
      ),
    );

    if (shouldExit ?? false) {
      print('Exit pressed');
      closeApp();
    }
  }

  Future<void> closeApp() async {
    if (kIsWeb) return;

    if (Platform.isAndroid || Platform.isIOS) {
      await SystemNavigator.pop();
    } else {
      // exit(0);
      print('before');
      exit(0);
      print('after');
    }
  }
}
