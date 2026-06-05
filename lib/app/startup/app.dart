import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_preperation_buddy/app/themes/app_theme.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/interview_questions_bloc/interview_questions_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_stt_bloc/question_stt_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/question_timer_bloc/question_timer_bloc.dart';
import 'package:interview_preperation_buddy/feature/questions/controllers/tts_bloc/tts_cubit.dart';
import 'package:interview_preperation_buddy/feature/questions/entity%20/question_answer_entity.dart';
import 'package:interview_preperation_buddy/feature/questions/screens/question_page.dart';
import '../../feature/interview/bloc/interview_bloc.dart';
import '../di/injection_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InterviewBloc>(create: (_) => sl<InterviewBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<TtsCubit>(create: (_) => sl<TtsCubit>()),
            BlocProvider<QuestionSttBloc>(create: (_) => sl<QuestionSttBloc>()),
            BlocProvider<QuestionTimerBloc>(
              create: (_) => sl<QuestionTimerBloc>(),
            ),
            BlocProvider<InterviewQuestionBloc>(
              create: (_) => sl<InterviewQuestionBloc>(
                param1: demoQuestions
                    .map(
                      (e) => QuestionAnswerEntity(
                        id: e['id'] as int,
                        question: e['question'] as String,
                        durationSeconds: e['durationSeconds'] as int,
                        difficulty: e['difficulty'] as String,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],

          child: QuestionPage(),
        ),
      ),
    );
  }
}

final demoQuestions = [
  {
    "id": 1,
    "question":
        "Explain the fundamental differences between `StatelessWidget` and `StatefulWidget` in Flutter. Provide a scenario where you would definitively choose one over the other, and briefly describe how their `build` methods are invoked.",

    "durationSeconds": 60,
    "difficulty": "Easy",
  },
  {
    "id": 2,
    "question":
        "Describe the concept of the Widget Tree and Element Tree in Flutter. What is `BuildContext`, and how does it relate to these trees when you need to access inherited widgets (like `Theme.of(context)`) or perform navigation?",

    "durationSeconds": 60,
    "difficulty": "Easy",
  },
  {
    "id": 3,
    "question":
        "You need to display a list of user profiles, where each profile item shows a user's avatar (circular image) on the left, their name (primary text) and a short bio (secondary text) stacked vertically on the right. How would you structure this using common Flutter layout widgets like `Row`, `Column`, `Expanded`, and `CircleAvatar`? Write a high-level pseudo-code for a single list item.",
    "durationSeconds": 60,
    "difficulty": "Easy",
  },
  {
    "id": 4,
    "question":
        "When fetching data from a REST API in Flutter, you'll often deal with asynchronous operations. Explain how you would typically fetch data using `async`/`await` and then display it in your UI. What Flutter widget is commonly used to handle the different states (loading, data, error) of an asynchronous operation and rebuild the UI accordingly?",
    "durationSeconds": 60,
    "difficulty": "Easy",
  },
  {
    "id": 5,
    "question":
        "Imagine you have two screens: `ProductListScreen` and `ProductDetailScreen`. How would you navigate from `ProductListScreen` to `ProductDetailScreen` and pass a `productId` to the detail screen? Additionally, if the `ProductDetailScreen` allows the user to 'favorite' a product, how would you communicate this 'favorited' status back to the `ProductListScreen` when returning?",
    "durationSeconds": 60,
    "difficulty": "Easy",
  },
];
