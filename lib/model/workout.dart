import 'exercise.dart';

class Workout {
  final int workoutId;
  final String workoutName;
  final String workoutDescription;
  final double totalWeightLifted;
  final DateTime lastWorkoutDate;
  final List<Exercise>? exerciseList;

  Workout({
    required this.workoutId,
    required this.workoutName,
    required this.workoutDescription,
    required this.lastWorkoutDate,
    required this.totalWeightLifted,
    required this.exerciseList,
  });
}
