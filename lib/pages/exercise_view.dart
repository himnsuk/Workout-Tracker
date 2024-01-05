import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/exercise_detail_tile.dart';
import 'package:workout_tracker/model/exercise.dart';
import 'package:workout_tracker/model/set_rep_weight_form_controller.dart';

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
  final newExerciseBodyPartController = TextEditingController(text: "CHEST");
  final List<SetRepWeightFormController> setRepWeights = [
    SetRepWeightFormController(
        set: TextEditingController(),
        weight: TextEditingController(text: "1.0"),
        rep: TextEditingController(text: "1"))
  ];
  late int intWorkoutId = int.parse(widget.workoutId.toString());
  late var pState = Provider.of<WorkoutTrackerState>(context, listen: false);
  late List<String> bodyPartList = pState.bodyPartList;
  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pState.fetchAllExerciseForWorkout(intWorkoutId);
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void addNewSet() {
    setState(() {
      setRepWeights.add(SetRepWeightFormController(
          set: TextEditingController(),
          weight: TextEditingController(text: "1.0"),
          rep: TextEditingController(text: "1")));
    });
  }

  // add new expense
  void addNewExercise() {
    context.pushNamed(
      'create-exercise',
      pathParameters: {'workout_id': "$intWorkoutId"},
    );
  }

  // Completed Workout
  void completeWorkout() {
    List<Exercise> exerciseList = [];
    for (var item in pState.currentExercises) {
      exerciseList.add(Exercise(
        exerciseId: item.exerciseId,
        workoutId: item.workoutId,
        exerciseOrder: item.exerciseOrder,
        exerciseName: item.exerciseName,
        bodyPart: item.bodyPart,
        exerciseDescription: item.exerciseDescription,
        status: "completed",
        setNumber: item.setNumber,
        weight: item.weight,
        reps: item.reps,
        createdAt: DateTime.now(),
        updatedAt: item.createdAt,
      ));
    }
    pState.addNewExercises(intWorkoutId, exerciseList);
    GoRouter.of(context).pop();
  }

  // cancel
  void cancel() {
    clear();
  }

  // clear controllers
  void clear() {
    Navigator.pop(context);
  }

  void _onItemTapped(int index) {
    if (index == 0 || index == 1) {
      GoRouter.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutTrackerState>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Workout Tracker",
              textAlign: TextAlign.center,
            ),
            actions: [
              IconButton(
                  onPressed: completeWorkout,
                  icon: const Icon(
                    Icons.save,
                    semanticLabel: "Save",
                  )),
            ]),
        body: ExerciseDetailTile(
          groupedExercise: value.groupedExercise,
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExercise,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
