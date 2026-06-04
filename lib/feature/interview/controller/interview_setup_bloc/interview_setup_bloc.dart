import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_event.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_state.dart';

class InterviewSetupBloc extends Bloc<InterviewSetupEvent, InterviewSetupState> {
  InterviewSetupBloc() : super(const InterviewSetupState()) {
    on<TechnologySelected>(_onTechnologySelected);
    on<ExperienceSelected>(_onExperienceSelected);
    on<FocusAreaChanged>(_onFocusAreaChanged);
  }

  void _onTechnologySelected(TechnologySelected event, Emitter<InterviewSetupState> emit) {
    emit(state.copyWith(selectedTechnology: event.technology));
  }

  void _onExperienceSelected(ExperienceSelected event, Emitter<InterviewSetupState> emit) {
    emit(state.copyWith(selectedExperience: event.experience));
  }

  void _onFocusAreaChanged(FocusAreaChanged event, Emitter<InterviewSetupState> emit) {
    emit(state.copyWith(focusArea: event.focusArea));
  }
}
