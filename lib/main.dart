import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/pages/create_exercise.dart';
import 'package:workout_tracker/pages/exercise_view.dart';
import 'package:workout_tracker/pages/home_page.dart';
import 'package:workout_tracker/state/workout_tracker_state.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => WorkoutTrackerState(),
      child: WorkoutTracker(),
    ),
  );
}

class WorkoutTracker extends StatelessWidget {
  WorkoutTracker({super.key});
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        // builder: (context, state) => const TestListView(),
        // builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/exercise/:workout_id',
        name: 'exercise',
        builder: (context, state) =>
            ExerciseView(workoutId: state.pathParameters['workout_id']),
      ),
      GoRoute(
        path: '/create-exercise/:workout_id',
        name: 'create-exercise',
        builder: (context, state) =>
            CreateExercise(workoutId: state.pathParameters['workout_id']),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
