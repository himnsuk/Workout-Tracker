import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_tracker/pages/auth/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workout_tracker/pages/detail_workout_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(WorkoutTracker());
}

class WorkoutTracker extends StatelessWidget {
  WorkoutTracker({super.key});
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/workout-details',
        builder: (context, state) => const DetailWorkoutScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   // home: const AuthPage(),
    //   theme: ThemeData(brightness: Brightness.light),
    //   routes: {
    //     '/': (context) => const AuthPage(),
    //   },
    // );
  }
}
