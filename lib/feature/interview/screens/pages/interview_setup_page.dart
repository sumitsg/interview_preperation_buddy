import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/app/routes/app_routes.dart';
import 'package:interview_preperation_buddy/app/startup/app.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/core/constants/interview_constants.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_bloc.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_event.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_state.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/experience_section.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/interview_setup_header.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/special_focus_area.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/technology_section.dart';
import 'package:interview_preperation_buddy/feature/questions/entity/question_answer_entity.dart'
    show QuestionAnswerEntity;
import 'package:interview_preperation_buddy/shared/widgets/app_button.dart';
import 'package:interview_preperation_buddy/shared/widgets/app_text.dart';
import 'package:interview_preperation_buddy/shared/widgets/responsive_container.dart';

class InterviewSetupPage extends StatefulWidget {
  const InterviewSetupPage({super.key});

  @override
  State<InterviewSetupPage> createState() => _InterviewSetupPageState();
}

class _InterviewSetupPageState extends State<InterviewSetupPage> {
  late final TextEditingController _focusAreaController;

  @override
  void initState() {
    super.initState();
    _focusAreaController = TextEditingController();
  }

  @override
  void dispose() {
    _focusAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 800),
          child: Column(
            children: [
              const InterviewSetupHeader(),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ResponsiveContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: AppText(
                                "Interview setup",
                                style: AppTextStyles.bodyLarge,
                              ),
                            ),

                            const SizedBox(height: 12),

                            //
                            Center(
                              child: AppText(
                                "Configure your mock interview parameters",
                                style: AppTextStyles.headline2,
                              ),
                            ),

                            //
                            const SizedBox(height: 32),
                            // TechnologySection(
                            //   onTechnologySelected: (value) {},
                            //   selectedTechnology: "Futter",
                            //   technologies: InterviewConstants.interviewTracks,
                            // ),

                            //
                            BlocSelector<
                              InterviewSetupBloc,
                              InterviewSetupState,
                              String?
                            >(
                              selector: (state) => state.selectedTechnology,
                              builder: (context, selectedTechnology) {
                                return TechnologySection(
                                  technologies:
                                      InterviewConstants.interviewTracks,
                                  selectedTechnology: selectedTechnology,
                                  onTechnologySelected: (technology) {
                                    context.read<InterviewSetupBloc>().add(
                                      TechnologySelected(technology),
                                    );
                                  },
                                );
                              },
                            ),

                            SizedBox(height: 32),
                            // ExperienceSection(
                            //   experiences: InterviewConstants.experienceLevels,
                            //   onExperienceSelected: (value) {},
                            //   selectedExperience: "3-5 Years",
                            // ),
                            BlocSelector<
                              InterviewSetupBloc,
                              InterviewSetupState,
                              String?
                            >(
                              selector: (state) => state.selectedExperience,
                              builder: (context, selectedExperience) {
                                return ExperienceSection(
                                  experiences:
                                      InterviewConstants.experienceLevels,
                                  selectedExperience: selectedExperience,
                                  onExperienceSelected: (experience) {
                                    context.read<InterviewSetupBloc>().add(
                                      ExperienceSelected(experience),
                                    );
                                  },
                                );
                              },
                            ),

                            SizedBox(height: 32),

                            // FocusAreaSection(controller: TextEditingController()),
                            FocusAreaSection(
                              controller: _focusAreaController,
                              onChanged: (value) {
                                context.read<InterviewSetupBloc>().add(
                                  FocusAreaChanged(value),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child:
                            BlocSelector<
                              InterviewSetupBloc,
                              InterviewSetupState,
                              bool
                            >(
                              selector: (state) => state.isFormValid,
                              builder: (context, isFormValid) {
                                return AppButton(
                                  title: "Start Interview",
                                  onPressed: isFormValid
                                      ? () {
                                          // context.read<InterviewSetupBloc>().add(StartInterviewPressed());
                                          final config = context
                                              .read<InterviewSetupBloc>()
                                              .state
                                              .interviewConfig;

                                          debugPrint(
                                            "Starting interview with config: $config",
                                          );

                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.questions,
                                            arguments: demoQuestions
                                                .map(
                                                  (e) => QuestionAnswerEntity(
                                                    id: e['id'] as int,
                                                    question:
                                                        e['question'] as String,
                                                    durationSeconds:
                                                        e['durationSeconds']
                                                            as int,
                                                    difficulty:
                                                        e['difficulty']
                                                            as String,
                                                  ),
                                                )
                                                .toList(),
                                          );
                                        }
                                      : null,
                                  icon: const Icon(Icons.arrow_forward_ios),
                                );
                              },
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
      ),
    );
  }
}
