class Exercise {
  final int exerciseId;
  final int workoutId;
  final int exerciseOrder;
  final String exerciseName;
  final String exerciseDescription;
  final String status;
  final String bodyPart;
  final int setNumber;
  final double weight;
  final int reps;
  final DateTime updatedAt;
  final DateTime createdAt;

  Exercise({
    required this.exerciseId,
    required this.workoutId,
    required this.exerciseOrder,
    required this.exerciseName,
    required this.exerciseDescription,
    required this.status,
    required this.bodyPart,
    required this.setNumber,
    required this.weight,
    required this.reps,
    required this.updatedAt,
    required this.createdAt,
  });
}
