import 'package:equatable/equatable.dart';

class InterviewSetupState extends Equatable {
  const InterviewSetupState({this.selectedTechnology, this.selectedExperience, this.focusArea = ''});

  final String? selectedTechnology;
  final String? selectedExperience;
  final String focusArea;

  bool get isFormValid => selectedTechnology != null && selectedExperience != null;

  InterviewSetupState copyWith({String? selectedTechnology, String? selectedExperience, String? focusArea}) {
    return InterviewSetupState(
      selectedTechnology: selectedTechnology ?? this.selectedTechnology,
      selectedExperience: selectedExperience ?? this.selectedExperience,
      focusArea: focusArea ?? this.focusArea,
    );
  }

  Map<String, dynamic> get interviewConfig => {
    'technology': selectedTechnology,
    'experience': selectedExperience,
    'focusArea': focusArea.trim(),
  };

  @override
  List<Object?> get props => [selectedTechnology, selectedExperience, focusArea];
}
