import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/components/workout_description_header.dart';

import '../components/excercise_tile.dart';
import '../components/home_header.dart';

class DetailWorkoutScreen extends StatefulWidget {
  const DetailWorkoutScreen({super.key});

  @override
  State<DetailWorkoutScreen> createState() => _DetailWorkoutScreenState();
}

class _DetailWorkoutScreenState extends State<DetailWorkoutScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Workout Tracker",
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
                onPressed: signOut,
                icon: const Icon(
                  Icons.logout,
                )),
          ]),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // for (var item in [1, 2, 3]) const HomeHeader(),
              const WorkoutDescriptionHeader(
                calorie: 54,
                daysWorkout: 3,
                hourSpent: 6,
              ),

              // for (var item in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
              for (var item in [1, 2, 3, 4])
                ExcerciseTile(
                  tileDetail: item,
                  // onTap: () => print(item),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
