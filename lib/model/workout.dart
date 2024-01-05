import 'exercise.dart';

class Workout {
  final int workoutId;
  final String workoutName;
  final String workoutDescription;
  final String status;
  final double totalWeightLifted;
  final DateTime lastWorkoutDate;
  final List<Exercise>? exerciseList;

  Workout({
    required this.workoutId,
    required this.workoutName,
    required this.workoutDescription,
    required this.status,
    required this.lastWorkoutDate,
    required this.totalWeightLifted,
    required this.exerciseList,
  });
}
