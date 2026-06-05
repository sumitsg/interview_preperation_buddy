import 'package:equatable/equatable.dart';
import 'package:interview_preperation_buddy/core/models/interview_question_model.dart';

class InterviewSetupState extends Equatable {
  const InterviewSetupState({
    this.selectedTechnology,
    this.selectedExperience,
    this.focusArea = '',
    this.error,
    this.isLoading = false,
    this.questions = const [],
  });

  final String? selectedTechnology;
  final String? selectedExperience;
  final String focusArea;
  final String? error;
  final bool isLoading;
  final List<InterviewQuestion> questions;

  bool get isFormValid => selectedTechnology != null && selectedExperience != null;

  InterviewSetupState copyWith({
    String? selectedTechnology,
    String? selectedExperience,
    String? focusArea,
    bool? isLoading,
    String? error,
    List<InterviewQuestion>? questions,
  }) {
    return InterviewSetupState(
      selectedTechnology: selectedTechnology ?? this.selectedTechnology,
      selectedExperience: selectedExperience ?? this.selectedExperience,
      focusArea: focusArea ?? this.focusArea,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> get interviewConfig => {
    'technology': selectedTechnology,
    'experience': selectedExperience,
    'focusArea': focusArea.trim(),
  };

  @override
  List<Object?> get props => [selectedTechnology, selectedExperience, focusArea, isLoading, error, questions];
}
