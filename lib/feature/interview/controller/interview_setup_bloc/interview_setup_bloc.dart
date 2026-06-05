import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_event.dart';
import 'package:interview_preperation_buddy/feature/interview/controller/interview_setup_bloc/interview_setup_state.dart';
import 'package:interview_preperation_buddy/feature/repo/interview_repository.dart';

class InterviewSetupBloc extends Bloc<InterviewSetupEvent, InterviewSetupState> {
  InterviewSetupBloc(this.repository) : super(const InterviewSetupState()) {
    on<TechnologySelected>(_onTechnologySelected);
    on<ExperienceSelected>(_onExperienceSelected);
    on<FocusAreaChanged>(_onFocusAreaChanged);
    on<GenerateQuestionsEvent>(_onGenerateQuestionsEvent);
  }

  final InterviewRepository repository;

  void _onTechnologySelected(TechnologySelected event, Emitter<InterviewSetupState> emit) {
    emit(state.copyWith(selectedTechnology: event.technology));
  }

  void _onExperienceSelected(ExperienceSelected event, Emitter<InterviewSetupState> emit) {
    emit(state.copyWith(selectedExperience: event.experience));
  }

  void _onFocusAreaChanged(FocusAreaChanged event, Emitter<InterviewSetupState> emit) {
    emit(state.copyWith(focusArea: event.focusArea));
  }

  Future<void> _onGenerateQuestionsEvent(GenerateQuestionsEvent event, Emitter<InterviewSetupState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final questions = await repository.generateQuestions(technology: event.technology, experience: event.experience);

      emit(state.copyWith(isLoading: false, questions: questions));
      // emit(state.copyWith(isLoading: true, questions: []));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString(), questions: []));
    }
  }
}
