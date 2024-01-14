import 'package:sqflite/sqflite.dart';
import 'package:workout_tracker/database/database_service.dart';

import '../model/exercise.dart';
import '../model/workout.dart';

class WorkoutTrackerDB {
  final workoutTable = 'workout';
  final exerciseTable = 'exercise';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $workoutTable (
      "workout_id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "workout_name" TEXT NOT NULL,
      "workout_description" TEXT NOT NULL,
      "status" TEXT NOT NULL,
      "total_weight_lifted" REAL NOT NULL,
      "updated_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int)),
      "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int))
    );""");

    await database.execute("""CREATE TABLE IF NOT EXISTS $exerciseTable (
      "exercise_id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "workout_id" INTEGER NOT NULL,
      "exercise_order" INTEGER NOT NULL,
      "exercise_name" TEXT NOT NULL,
      "exercise_description" TEXT NOT NULL,
      "body_part" TEXT NOT NULL,
      "status" TEXT NOT NULL,
      "set_number" INTEGER NOT NULL,
      "weight_used" REAL NOT NULL,
      "repetition" INTEGER NOT NULL,
      "updated_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int)),
      "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int)),
      FOREIGN KEY (workout_id) REFERENCES $workoutTable (workout_id)
    );""");
  }

  Future<int?> createWorkout(
      {required String workoutName,
      required String workoutDescription,
      required String status,
      required double totalWeightLifted,
      required DateTime updatedAt,
      required DateTime createdAt}) async {
    final database = await DatabaseService().database;
    return await database?.rawInsert("""INSERT INTO $workoutTable (
          workout_name, 
          workout_description, 
          status, 
          total_weight_lifted, 
          updated_at, 
          created_at
        ) VALUES (?, ?, ?, ?, ?, ?)""", [
      workoutName,
      workoutDescription,
      status,
      totalWeightLifted,
      DateTime.now().millisecondsSinceEpoch,
      DateTime.now().millisecondsSinceEpoch
    ]);
  }

  Future<int?> updateWorkout(int workoutId, double totalWeight) async {
    final database = await DatabaseService().database;
    return await database?.rawUpdate("""
    UPDATE $workoutTable SET total_weight_lifted = $totalWeight
    WHERE workout_id = $workoutId""");
  }

  void createExercise({
    required workoutId,
    required totalWeightLifted,
    required exerciseList,
  }) async {
    final database = await DatabaseService().database;
    var batch = database?.batch();

    for (var item in exerciseList) {
      batch?.insert(exerciseTable, {
        'workout_id': item.workoutId,
        'exercise_order': item.exerciseOrder,
        'exercise_name': item.exerciseName,
        'exercise_description': item.exerciseDescription,
        'status': item.status,
        'body_part': item.bodyPart,
        'set_number': item.setNumber,
        'weight_used': item.weight,
        'repetition': item.reps,
        'updated_at': item.updatedAt.millisecondsSinceEpoch,
        'created_at': item.createdAt.millisecondsSinceEpoch
      });
    }
    await batch?.commit(noResult: true);
    updateWorkout(workoutId, totalWeightLifted);
  }

  void completeExercise(Workout workout, List<Exercise> exerciseList) async {
    final database = await DatabaseService().database;
    var batch = database?.batch();
    int? workoutIdCreated = await createWorkout(
        workoutName: workout.workoutName,
        workoutDescription: workout.workoutDescription,
        status: "completed",
        totalWeightLifted: workout.totalWeightLifted,
        updatedAt: DateTime.now(),
        createdAt: workout.lastWorkoutDate);

    for (var item in exerciseList) {
      batch?.insert(exerciseTable, {
        'workout_id': workoutIdCreated,
        'exercise_order': item.exerciseOrder,
        'exercise_name': item.exerciseName,
        'exercise_description': item.exerciseDescription,
        'status': item.status,
        'body_part': item.bodyPart,
        'set_number': item.setNumber,
        'weight_used': item.weight,
        'repetition': item.reps,
        'updated_at': item.updatedAt.millisecondsSinceEpoch,
        'created_at': item.createdAt.millisecondsSinceEpoch
      });
    }
    await batch?.commit(noResult: true);
  }

  Future<List?> fetchLatestWorkout() async {
    final database = await DatabaseService().database;
    final workoutListDB = await database?.rawQuery("""SELECT T.* FROM(
          SELECT *, ROW_NUMBER() OVER(PARTITION BY workout_name ORDER BY updated_at DESC) AS RowNum
          FROM $workoutTable
          WHERE status != "removed") T WHERE RowNum = 1""");
    return workoutListDB;
  }

  Future<List?> fetchAllWorkoutDetails() async {
    final database = await DatabaseService().database;
    final workoutListDB =
        await database?.rawQuery("""SELECT * FROM $workoutTable""");
    // await database?.rawQuery("""SELECT * from $workoutTable""");
    return workoutListDB;
  }

  Future<List?> fetchAllExercise(int workoutId) async {
    final database = await DatabaseService().database;
    final exerciseListDB =
        await database?.rawQuery("""SELECT * from $exerciseTable""");
    return exerciseListDB;
  }

  Future<List?> fetchAllExerciseForWorkout(int workoutId) async {
    final database = await DatabaseService().database;
    final exerciseListDB = await database?.rawQuery("""
        SELECT T.* FROM(
          SELECT *, ROW_NUMBER() OVER(PARTITION BY exercise_name,set_number ORDER BY updated_at DESC) AS ROWNumber
          FROM $exerciseTable
          WHERE status != "removed" and workout_id = $workoutId) T WHERE ROWNumber = 1""");
    return exerciseListDB;
  }

  Future<int?> deleteWorkout(int workoutId) async {
    final database = await DatabaseService().database;
    await database?.rawUpdate(
        """UPDATE $exerciseTable SET status = "removed" WHERE workout_id = $workoutId""");
    var delWorkoutRow = await database?.rawUpdate(
        """UPDATE $workoutTable SET status = "removed" WHERE workout_id = $workoutId""");
    return delWorkoutRow;
  }

  Future<int?> deleteExercise(int exerciseId) async {
    final database = await DatabaseService().database;
    final deleteExerciseFromDB = await database?.rawUpdate(
        """UPDATE $exerciseTable SET status = "removed" WHERE exercise_id = $exerciseId""");
    return deleteExerciseFromDB;
  }

  void dropTable() async {
    final database = await DatabaseService().database;
    await database?.execute("""DROP TABLE IF EXISTS $workoutTable""");
    await database?.execute("""DROP TABLE IF EXISTS $exerciseTable""");
  }
}
