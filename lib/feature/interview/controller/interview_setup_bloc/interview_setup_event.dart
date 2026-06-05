abstract class InterviewSetupEvent {}

class TechnologySelected extends InterviewSetupEvent {
  TechnologySelected(this.technology);

  final String technology;
}

class ExperienceSelected extends InterviewSetupEvent {
  ExperienceSelected(this.experience);

  final String experience;
}

class FocusAreaChanged extends InterviewSetupEvent {
  FocusAreaChanged(this.focusArea);

  final String focusArea;
}

class GenerateQuestionsEvent extends InterviewSetupEvent {
  final String technology;
  final String experience;

  GenerateQuestionsEvent({required this.technology, required this.experience});

  // @override
  // List<Object?> get props => [technology, experience];
}
