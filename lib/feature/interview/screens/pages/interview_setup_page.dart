import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/app/themes/app_colors.dart';
import 'package:interview_preperation_buddy/app/routes/app_routes.dart';
import 'package:interview_preperation_buddy/app/startup/app.dart';
import 'package:interview_preperation_buddy/app/themes/app_text_style.dart';
import 'package:interview_preperation_buddy/core/constants/interview_constants.dart';
import 'package:interview_preperation_buddy/core/responsive/responsive.dart';
import 'package:interview_preperation_buddy/feature/feedback/screens/pages/evaluation_page.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_bloc.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_event.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_state.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/experience_section.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/interview_setup_header.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/special_focus_area.dart';
import 'package:interview_preperation_buddy/feature/interview/screens/widgets/technology_section.dart';
import 'package:interview_preperation_buddy/feature/questions/entity%20/question_answer_entity.dart'
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
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
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
                              Center(child: AppText("Interview setup", style: AppTextStyles.headline2)),

                              const SizedBox(height: 12),

                              //
                              Center(
                                child: AppText(
                                  "Configure your mock interview parameters",
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyLarge,
                                ),
                              ),

                              //
                              const SizedBox(height: 32),
                              Divider(indent: 2, endIndent: 2),
                              const SizedBox(height: 32),

                              BlocSelector<InterviewSetupBloc, InterviewSetupState, String?>(
                                selector: (state) => state.selectedTechnology,
                                builder: (context, selectedTechnology) {
                                  return TechnologySection(
                                    technologies: InterviewConstants.interviewTracks,
                                    selectedTechnology: selectedTechnology,
                                    onTechnologySelected: (technology) {
                                      context.read<InterviewSetupBloc>().add(TechnologySelected(technology));
                                    },
                                  );
                                },
                              ),

                              //
                              const SizedBox(height: 32),

                              BlocSelector<InterviewSetupBloc, InterviewSetupState, String?>(
                                selector: (state) => state.selectedExperience,
                                builder: (context, selectedExperience) {
                                  return ExperienceSection(
                                    experiences: InterviewConstants.experienceLevels,
                                    selectedExperience: selectedExperience,
                                    onExperienceSelected: (experience) {
                                      context.read<InterviewSetupBloc>().add(ExperienceSelected(experience));
                                    },
                                  );
                                },
                              ),

                              SizedBox(height: 32),

                              FocusAreaSection(
                                controller: _focusAreaController,
                                onChanged: (value) {
                                  context.read<InterviewSetupBloc>().add(FocusAreaChanged(value));
                                },
                              ),

                              SizedBox(height: 64),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: BlocConsumer<InterviewSetupBloc, InterviewSetupState>(
                                  listener: (context, state) {
                                    if (state.questions.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => EvaluationPage()),
                                      );
                                    } else {}
                                  },
                                  // selector: (state) => [state.isFormValid, state.isLoading],
                                  builder: (context, state) {
                                    if (state.isLoading == true) {
                                      return Center(child: CircularProgressIndicator(color: AppColors.primary));
                                    }
                                    return AppButton(
                                      width: double.maxFinite,
                                      title: "Start Interview",
                                      onPressed: state.isFormValid
                                          ? () {
                                              // context.read<InterviewSetupBloc>().add(StartInterviewPressed());
                                              final config = context.read<InterviewSetupBloc>().state.interviewConfig;
                                              final technology = config['technology'] as String;
                                              final experience = config['experience'] as String;
                                              final focusArea = config['focusArea'] as String;

                                              // calling the event to get teh question...
                                              context.read<InterviewSetupBloc>().add(
                                                GenerateQuestionsEvent(technology: technology, experience: experience),
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

                        //
                      ],
                    ),
                  ),
                ),

                // const StartInterviewButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
