import 'package:flutter/material.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/interview_setup_header.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/technology_section.dart';
import 'package:interview_preperation_buddy/shared/widgets/responsive_container.dart';

class InterviewSetupPage extends StatelessWidget {
  const InterviewSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const InterviewSetupHeader(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ResponsiveContainer(
                      child: Column(
                        children: [
                          TechnologySection(
                            onTechnologySelected: (value) {},
                            selectedTechnology: "Futter",
                            technologies: ["Flutter", "Ios", "React"],
                          ),
                          SizedBox(height: 32),

                          // ExperienceSection(),
                          SizedBox(height: 32),

                          // FocusAreaSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // const StartInterviewButton(),
          ],
        ),
      ),
    );
  }
}
