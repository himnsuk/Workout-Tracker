import 'package:sqflite/sqflite.dart';
import 'package:workout_tracker/database/database_service.dart';

class WorkoutTrackerDB {
  final workoutTable = 'workout';
  final exerciseTable = 'exercise';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $workoutTable (
      "workout_id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "workout_name" TEXT NOT NULL,
      "workout_description" TEXT NOT NULL,
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
      required double totalWeightLifted,
      required DateTime updatedAt,
      required DateTime createdAt}) async {
    final database = await DatabaseService().database;
    return await database?.rawInsert(
        """INSERT INTO $workoutTable (workout_name, workout_description, total_weight_lifted, updated_at, created_at) VALUES (?, ?, ?, ?, ?)""",
        [
          workoutName,
          workoutDescription,
          totalWeightLifted,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch
        ]);
  }

  Future<int?> createExercise(
      {required workoutId,
      required order,
      required excerciseName,
      required excerciseDescription,
      required bodyPart,
      required weightUsed,
      required reps,
      required updatedAt,
      required createdAt}) async {
    final database = await DatabaseService().database;
    return await database?.rawInsert(
        """INSERT INTO $exerciseTable (workout_id,exercise_order, exercise_name, exercise_description, body_part, weight_used, repetition, updated_at, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)""",
        [
          workoutId,
          order,
          excerciseName,
          excerciseDescription,
          bodyPart,
          weightUsed,
          reps,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch
        ]);
  }

  Future<List?> fetchAllWorkout() async {
    final database = await DatabaseService().database;
    final workoutListDB =
        await database?.rawQuery("""SELECT * from $workoutTable""");
    return workoutListDB;
  }

  Future<List?> fetchAllExerciseForworkout(int workoutId) async {
    final database = await DatabaseService().database;
    final exerciseListDB = await database?.rawQuery("""SELECT * from $exerciseTable where workout_id = $workoutId""");
    // final exerciseListDB = await database?.rawQuery("""SELECT * from $exerciseTable""");
    return exerciseListDB;
  }

  Future<int?> deleteWorkout(int workoutId) async {
    final database = await DatabaseService().database;
    final deleteWorkoutFromDB = await database?.rawDelete(
        """DELETE FROM $workoutTable WHERE workout_id = $workoutId""");
    return deleteWorkoutFromDB;
  }

  void dropTable() async {
    final database = await DatabaseService().database;
    await database?.execute("""DROP TABLE IF EXISTS $workoutTable""");
    await database?.execute("""DROP TABLE IF EXISTS $exerciseTable""");
  }
}
