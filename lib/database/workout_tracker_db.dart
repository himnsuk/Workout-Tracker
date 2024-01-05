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
    return await database?.rawInsert(
        """INSERT INTO $workoutTable (workout_name, workout_description, status, total_weight_lifted, updated_at, created_at) VALUES (?, ?, ?, ?, ?, ?)""",
        [
          workoutName,
          workoutDescription,
          status,
          totalWeightLifted,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch
        ]);
  }

  void createExercise({required exerciseList}) async {
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

    batch?.commit(noResult: true);
  }

  Future<List?> fetchAllWorkout() async {
    final database = await DatabaseService().database;
    final workoutListDB =
        await database?.rawQuery("""SELECT * from $workoutTable""");
    return workoutListDB;
  }

  Future<List?> fetchAllExerciseForWorkout(int workoutId) async {
    final database = await DatabaseService().database;
    final exerciseListDB = await database?.rawQuery("""
        SELECT T.* FROM(
          SELECT *, ROW_NUMBER() OVER(PARTITION BY exercise_name,set_number ORDER BY updated_at DESC) AS ROWNumber
          FROM $exerciseTable
          WHERE workout_id = $workoutId and status in ('created', 'updated')) T WHERE ROWNumber = 1""");
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
