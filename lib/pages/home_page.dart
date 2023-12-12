import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/components/excercise_tile.dart';
import 'package:workout_tracker/components/home_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              const HomeHeader(
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
