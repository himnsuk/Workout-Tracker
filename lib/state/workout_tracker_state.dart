import 'package:flutter/material.dart';
import 'package:workout_tracker/database/workout_tracker_db.dart';
import 'package:workout_tracker/model/exercise.dart';

import '../model/workout.dart';

class WorkoutTrackerState with ChangeNotifier {
  // List of Workout
  List<Workout> workoutList = [];

  // // get Current Workout
  // late Workout currentWorkout;

  // List current Exercises
  List<Exercise> currentExercises = [];

  var db = WorkoutTrackerDB();

  // Add new workout
  void addNewWorkout(Workout workout) {
    workoutList.add(workout);
    insertWorkoutIntoDatabase(workout);
    notifyListeners();
  }

  void addNewExercise(int index, Exercise exercise) {
    workoutList
        .firstWhere((x) => x.workoutId == index)
        .exerciseList
        ?.add(exercise);
    var y = insertExerciseIntoTable(index, exercise);
    print(y);
    notifyListeners();
  }

  Future<int?> insertWorkoutIntoDatabase(Workout workout) async {
    var x = await db.createWorkout(
        workoutName: workout.workoutName,
        createdAt: workout.lastWorkoutDate,
        workoutDescription: workout.workoutDescription,
        totalWeightLifted: workout.totalWeightLifted,
        updatedAt: workout.lastWorkoutDate);
    return x;
  }

  Future<int?> insertExerciseIntoTable(int workoutId, Exercise exercise) async {
    var x = await db.createExercise(
        workoutId: workoutId,
        order: exercise.exerciseOrder,
        excerciseName: exercise.exerciseName,
        excerciseDescription: exercise.exerciseDescription,
        bodyPart: exercise.bodyPart,
        weightUsed: exercise.weightUsed,
        reps: exercise.reps,
        updatedAt: exercise.updatedAt,
        createdAt: exercise.createdAt);
    return x;
  }

  void fetchAllWorkout() async {
    var wkoutFromTbl = await db.fetchAllWorkout();
    workoutList.clear();
    for (var item in wkoutFromTbl!) {
      workoutList.add(Workout(
          workoutId: item['workout_id'],
          workoutName: item['workout_name'],
          workoutDescription: item['workout_description'],
          lastWorkoutDate:
              DateTime.fromMillisecondsSinceEpoch(item['updated_at']),
          totalWeightLifted: item['total_weight_lifted'],
          exerciseList: []));
    }
    notifyListeners();
  }

  void fetchAllExerciseForWorkout(int workoutId) async {
    var exerciseListFromTbl = await db.fetchAllExerciseForworkout(workoutId);
    var getWorkout = workoutList.firstWhere((x) => x.workoutId == workoutId);
    getWorkout.exerciseList?.clear();
    for (var item in exerciseListFromTbl!) {
      getWorkout.exerciseList?.add(
        Exercise(
            exerciseId: item['exercise_id'],
            exerciseOrder: item['exercise_order'],
            exerciseName: item['exercise_name'],
            exerciseDescription: item['exercise_description'],
            bodyPart: item['body_part'],
            weightUsed: item['weight_used'],
            reps: item['repetition'],
            updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updated_at']),
            createdAt: DateTime.fromMillisecondsSinceEpoch(item['created_at'])),
      );
    }
    currentExercises = getWorkout.exerciseList!;
    notifyListeners();
  }

  void dropTable() async {
    db.dropTable();
  }
}
