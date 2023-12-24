import 'package:flutter/material.dart';

import '../model/exercise.dart';
import 'create_workout_header.dart';

class ExerciseDetailTile extends StatefulWidget {
  final List<Exercise> exerciseList;
  const ExerciseDetailTile({
    super.key,
    required this.exerciseList,
  });

  @override
  State<ExerciseDetailTile> createState() => _ExerciseDetailTileState();
}

class _ExerciseDetailTileState extends State<ExerciseDetailTile> {
  double _weight = 2.5;
  double _reps = 1;

  void updateWeight(updateType) {
    setState(() {
      if (updateType == 'increase') {
        _weight += 2.5;
      } else if (_weight > 2.5) {
        _weight -= 2.5;
      }
    });
  }

  void updateReps(updateType) {
    setState(() {
      if (updateType == 'increase') {
        _reps += 1;
      } else if (_reps > 1) {
        _reps -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CreateWorkoutHeader(),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.exerciseList.length,
              itemBuilder: (BuildContext context, int index) => Card(
                child: ListTile(
                  leading: Icon(Icons.fitness_center),
                  title: Row(
                    children: [
                      SizedBox(
                        child: Text(widget.exerciseList[index].exerciseName),
                        width: 120,
                      ),
                      const Spacer(),
                      SizedBox(
                        child: Text(
                          "${widget.exerciseList[index].weightUsed}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        width: 40,
                      ),
                      const Spacer(),
                      SizedBox(
                        child: Text(
                          "${widget.exerciseList[index].reps}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        width: 40,
                      ),
                    ],
                  ),
                  subtitle: Text(widget.exerciseList[index].bodyPart),
                  trailing: Icon(Icons.delete),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
