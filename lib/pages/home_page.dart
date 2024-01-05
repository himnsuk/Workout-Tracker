import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/workout_tile.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:workout_tracker/state/workout_tracker_state.dart';

import '../model/workout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final newWorkoutNameController = TextEditingController();
  final newWorkoutDescriptionController = TextEditingController();

  @override
  void initState() {
    initDB();
    super.initState();
    var pState = Provider.of<WorkoutTrackerState>(context, listen: false);
    // pState.dropTable();
    pState.fetchAllWorkout();
  }

  void initDB() async {
    var db = DatabaseService();
    await db.database;
    await db.createTables;
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // add new workout
  void addNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add new Workout"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                // Workout name
                TextField(
                  controller: newWorkoutNameController,
                  decoration: const InputDecoration(hintText: "Workout Name"),
                ),

                // Workout Description
                TextField(
                  controller: newWorkoutDescriptionController,
                  decoration:
                      const InputDecoration(hintText: "Workout Description"),
                ),
              ]),
              actions: [
                // save button
                MaterialButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
                // cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: const Text('Cancel'),
                ),
              ],
            ));
  }

  // save
  void save() {
    var pState = Provider.of<WorkoutTrackerState>(context, listen: false);
    // create a new workout
    Workout newWorkout = Workout(
      workoutId: 1,
      workoutName: newWorkoutNameController.text,
      workoutDescription: newWorkoutDescriptionController.text,
      status: "created",
      lastWorkoutDate: DateTime.now(),
      totalWeightLifted: 0,
      exerciseList: [],
    );

    pState.addNewWorkout(newWorkout);

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
    newWorkoutNameController.clear();
    newWorkoutDescriptionController.clear();
  }

  // clear tables
  void removeTables() {
    var pState = Provider.of<WorkoutTrackerState>(context, listen: false);
    pState.dropTable();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutTrackerState>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Workout Tracker Home",
            textAlign: TextAlign.center,
          ),
        ),
        body: WorkoutTile(
          workoutList: value.workoutList,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewWorkout,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
