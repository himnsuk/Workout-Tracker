class Exercise {
  final int exerciseId;
  final int exerciseOrder;
  final String exerciseName;
  final String exerciseDescription;
  final String bodyPart;
  final double weightUsed;
  final int reps;
  final DateTime updatedAt;
  final DateTime createdAt;

  Exercise({
    required this.exerciseId,
    required this.exerciseOrder,
    required this.exerciseName,
    required this.exerciseDescription,
    required this.bodyPart,
    required this.weightUsed,
    required this.reps,
    required this.updatedAt,
    required this.createdAt,
  });
}
