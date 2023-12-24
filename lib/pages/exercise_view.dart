import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/create_exercise_popup.dart';
import 'package:workout_tracker/components/exercise_detail_tile.dart';
import 'package:workout_tracker/model/exercise.dart';

import '../state/workout_tracker_state.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({
    super.key,
    required this.workoutId,
  });

  final String? workoutId;

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  final newExerciseNameController = TextEditingController();
  final newExerciseDescriptionController = TextEditingController();
  final newExerciseWeightController = TextEditingController(text: "1.0");
  final newExerciseRepsController = TextEditingController(text: "1");
  late int intWorkoutId = int.parse(widget.workoutId.toString());
  late var pState = Provider.of<WorkoutTrackerState>(context, listen: false);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pState.fetchAllExerciseForWorkout(intWorkoutId);
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // add new expense
  void addNewExercise() {
    showDialog(
      context: context,
      builder: (context) => CreateExercisePopup(
        nameController: newExerciseNameController,
        descriptionController: newExerciseDescriptionController,
        weightController: newExerciseWeightController,
        repsController: newExerciseRepsController,
        save: save,
        cancel: cancel,
      ),
    );
  }

  // save
  void save() {
    Exercise newExercise = Exercise(
      exerciseId: 1,
      exerciseOrder: 1,
      exerciseName: newExerciseNameController.text,
      bodyPart: "full body",
      exerciseDescription: newExerciseDescriptionController.text,
      weightUsed: double.parse(newExerciseWeightController.text),
      reps: int.parse(newExerciseRepsController.text),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    pState.addNewExercise(intWorkoutId, newExercise);
    Navigator.pop(context);
    clear();
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear controllers
  void clear() {
    newExerciseNameController.clear();
    newExerciseDescriptionController.clear();
    newExerciseWeightController.clear();
    newExerciseRepsController.clear();
  }

  void _onItemTapped(int index) {
    print(index);
    if (index == 0 || index == 1) {
      GoRouter.of(context).pop();
    }
    // setState(() {
    //   _selectedIndex = index;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutTrackerState>(
      builder: (context, value, child) => Scaffold(
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
        body: ExerciseDetailTile(
          exerciseList: value.currentExercises,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_left),
              label: 'Back',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_right),
              label: 'Forward',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          // onTap: GoRouter.of(context).go("/"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExercise,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
