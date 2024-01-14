import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:workout_tracker/database/workout_tracker_db.dart';
import 'package:workout_tracker/model/exercise.dart';

import '../model/workout.dart';

class WorkoutTrackerState with ChangeNotifier {
  // Body Part List
  List<String> bodyPartList = [
    'CHEST',
    'BACK',
    'ARM',
    'ABDOMINAL',
    'LEG',
    'SHOULDER'
  ];

  // List of Workout
  List<Workout> workoutList = [];

  // // get Current Workout
  // late Workout currentWorkout;

  // List current Exercises
  List<Exercise> currentExercises = [];

  // Group Exercises by Name
  Map<String, List<Exercise>> groupedExercise = {};

  var db = WorkoutTrackerDB();

  // Add new workout
  void addNewWorkout(Workout workout) {
    workoutList.add(workout);
    insertWorkoutIntoDatabase(workout);
    notifyListeners();
  }

  void addNewExercises(
      int index, List<Exercise> exerciseList, double totalWeightLifted) {
    workoutList
        .firstWhere((x) => x.workoutId == index)
        .exerciseList
        ?.addAll(exerciseList);
    db.createExercise(
        workoutId: index,
        totalWeightLifted: totalWeightLifted,
        exerciseList: exerciseList);
    notifyListeners();
  }

  void completeExercise(Workout workout, List<Exercise> exerciseList) {
    db.completeExercise(workout, exerciseList);
  }

  Future<int?> insertWorkoutIntoDatabase(Workout workout) async {
    var x = await db.createWorkout(
        workoutName: workout.workoutName,
        createdAt: workout.lastWorkoutDate,
        workoutDescription: workout.workoutDescription,
        status: workout.status,
        totalWeightLifted: workout.totalWeightLifted,
        updatedAt: workout.lastWorkoutDate);
    return x;
  }

  // void insertExerciseIntoTable(
  //     int workoutId, List<Exercise> exerciseList) async {
  //   db.createExercise(exerciseList: exerciseList);
  // }

  void fetchAllWorkout() async {
    // var latestWorkout = await db.fetchAllWorkoutDetails();
    // print(latestWorkout);
    var wkoutFromTbl = await db.fetchLatestWorkout();
    print(wkoutFromTbl);
    workoutList.clear();
    for (var item in wkoutFromTbl!) {
      workoutList.add(Workout(
          workoutId: item['workout_id'],
          workoutName: item['workout_name'],
          workoutDescription: item['workout_description'],
          status: item['status'],
          lastWorkoutDate:
              DateTime.fromMillisecondsSinceEpoch(item['updated_at']),
          totalWeightLifted: item['total_weight_lifted'],
          exerciseList: []));
    }
    notifyListeners();
  }

  void fetchAllExerciseForWorkout(int workoutId) async {
    var exerciseListFromTbl = await db.fetchAllExerciseForWorkout(workoutId);
    var getWorkout = workoutList.firstWhere((x) => x.workoutId == workoutId);
    getWorkout.exerciseList?.clear();
    for (var item in exerciseListFromTbl!) {
      getWorkout.exerciseList?.add(
        Exercise(
            exerciseId: item['exercise_id'],
            workoutId: workoutId,
            exerciseOrder: item['exercise_order'],
            exerciseName: item['exercise_name'],
            exerciseDescription: item['exercise_description'],
            status: item['status'],
            bodyPart: item['body_part'],
            reps: item['repetition'],
            updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updated_at']),
            createdAt: DateTime.fromMillisecondsSinceEpoch(item['created_at']),
            setNumber: item['set_number'],
            weight: item['weight_used']),
      );
    }
    currentExercises = getWorkout.exerciseList!;
    // var allExercise = await db.fetchAllExercise(workoutId);
    groupedExercise = groupBy(currentExercises, (obj) => obj.exerciseName);
    notifyListeners();
  }

  Future<int?> deleteExercise(Exercise exercise) async {
    var delExerciseRow = await db.deleteExercise(exercise.exerciseId);
    fetchAllExerciseForWorkout(exercise.workoutId);
    return delExerciseRow;
  }

  Future<int?> deleteWorkout(int workoutId) async {
    var delWorkoutRow = await db.deleteWorkout(workoutId);
    fetchAllWorkout();
    // notifyListeners();
    return delWorkoutRow;
  }

  void dropTable() async {
    db.dropTable();
    notifyListeners();
  }
}
