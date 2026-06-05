import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/core/responsive/responsive.dart';
import 'package:interview_preperation_buddy/feature/interview/widgets/recording_wave.dart';
import 'package:interview_preperation_buddy/feature/interview/widgets/technology_selector.dart';
import 'package:interview_preperation_buddy/feature/questions/widgets/recording_panel.dart';
import 'package:interview_preperation_buddy/feature/questions/widgets/voice_wave.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_badge.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_button.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_card.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_stat_tile.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_textfield.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_timer.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  final TextEditingController focusController = TextEditingController();

  String selectedTechnology = 'Flutter';

  @override
  void dispose() {
    focusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.width(context);
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Showcase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Width: $width'),
            const SizedBox(height: 12),

            Text('Mobile: $isMobile'),
            const SizedBox(height: 12),

            Text('Tablet: $isTablet'),
            const SizedBox(height: 12),

            Text('Desktop: $isDesktop'),
            const SizedBox(height: 12),
            const Text('Buttons', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            AppButton(title: 'Start Interview', onPressed: () {}),

            const SizedBox(height: 24),

            const Text('Card', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            const AppCard(child: Text('This is AppCard Widget')),

            const SizedBox(height: 24),

            const Text('Chips', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            const SizedBox(height: 24),

            const Text('Text Field', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            AppTextField(controller: focusController, hintText: 'Enter your focus area here...', maxLines: 4),

            const SizedBox(height: 24),

            const Text('Badges', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            const Wrap(
              spacing: 10,
              children: [
                AppBadge(title: 'Recording', color: Colors.red),
                AppBadge(title: 'Medium', color: Colors.orange),
                AppBadge(title: 'Completed', color: Colors.green),
              ],
            ),

            const SizedBox(height: 24),

            const Text('Stats', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            const Row(
              children: [
                Expanded(
                  child: AppStatTile(title: 'Words', value: '124'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: AppStatTile(title: 'Questions', value: '5'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text('Timer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            Center(
              child: AppTimer(
                seconds: 60,
                onCompleted: () {
                  debugPrint('Timer Completed');
                },
              ),
            ),

            const SizedBox(height: 40),
            RecordingPanel(duration: 20, wordCount: 50, onTimerCompleted: () {}),
            const SizedBox(height: 40),
            VoiceWave(barCount: 10),
            const SizedBox(height: 40),
            TechnologySelector(
              onSelected: (value) {},
              selectedTechnology: "Flutter",
              technologies: ["ios", "Flutter", "React", "Swift", "Data structure and also"],
            ),
            const SizedBox(height: 40),
            const RecordingWave(),
            const SizedBox(height: 40),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
