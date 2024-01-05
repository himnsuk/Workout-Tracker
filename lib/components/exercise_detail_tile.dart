import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/exercise.dart';
import '../state/workout_tracker_state.dart';

class ExerciseDetailTile extends StatefulWidget {
  final Map<String, List<Exercise>> groupedExercise;
  const ExerciseDetailTile({
    super.key,
    required this.groupedExercise,
  });

  @override
  State<ExerciseDetailTile> createState() => _ExerciseDetailTileState();
}

class _ExerciseDetailTileState extends State<ExerciseDetailTile> {
  late var pState = Provider.of<WorkoutTrackerState>(context, listen: false);

  void deleteExercise(Exercise exercise) {
    pState.deleteExercise(exercise);
  }

  void save(Exercise item, double weight, int reps) {
    List<Exercise> newExercise = [
      Exercise(
          exerciseId: item.exerciseId,
          workoutId: item.workoutId,
          exerciseOrder: item.exerciseOrder,
          exerciseName: item.exerciseName,
          exerciseDescription: item.exerciseDescription,
          status: "updated",
          bodyPart: item.bodyPart,
          setNumber: item.setNumber,
          weight: weight,
          reps: reps,
          updatedAt: DateTime.now(),
          createdAt: item.createdAt)
    ];
    pState.addNewExercises(item.workoutId, newExercise);
    Navigator.pop(context);
  }

  void cancel() {
    Navigator.pop(context);
  }

  // edit a exercise
  void editExercise(Exercise item) {
    double weight = item.weight;
    int reps = item.reps;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        void updateWeight(String updateType) {
          setState(() {
            if (updateType == 'increase') {
              weight += 2.5;
            } else if (weight > 2.5) {
              weight -= 2.5;
            }
          });
        }

        void updateReps(updateType) {
          setState(() {
            if (updateType == 'increase') {
              reps += 1;
            } else if (reps > 1) {
              reps -= 1;
            }
          });
        }

        return AlertDialog(
          title: Text(
            item.exerciseName,
            textAlign: TextAlign.center,
          ),
          content: Builder(builder: (context) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                "Set ${item.setNumber}",
                textAlign: TextAlign.center,
              ),
              const Text("Weight"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outlined,
                      color: Colors.blue,
                    ),
                    onPressed: () => updateWeight("decrease"),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      "$weight",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outlined,
                      color: Colors.blue,
                    ),
                    onPressed: () => updateWeight("increase"),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 2,
                color: Colors.blue,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Reps"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outlined,
                      color: Colors.blue,
                    ),
                    onPressed: () => updateReps("decrease"),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      "${reps}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outlined,
                      color: Colors.blue,
                    ),
                    onPressed: () => updateReps("increase"),
                  ),
                ],
              )
            ]);
          }),
          actions: [
            // save button
            MaterialButton(
              onPressed: () => save(item, weight, reps),
              child: const Text('Save'),
            ),
            // cancel button
            MaterialButton(
              onPressed: cancel,
              child: const Text('Cancel'),
            ),
          ],
        );
      }),
    );
  }

  List<Widget> createExerciseView() {
    List<Widget> exerciseListView = [
      Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  "Set",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  "Weight",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  "Rep",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () => {},
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => {},
              ),
            ],
          ),
        ),
      ),
    ];
    widget.groupedExercise.forEach((exerciseName, exerciseList) {
      exerciseListView.add(Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: Row(
          children: [
            const Expanded(
              child: Divider(),
            ),
            Text(
              exerciseName,
              style: const TextStyle(fontSize: 18),
            ),
            const Expanded(
              child: Divider(),
            ),
          ],
        ),
      ));
      for (var item in exerciseList) {
        exerciseListView.add(
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Text("${item.setNumber}"),
                  const Spacer(),
                  Text("${item.weight}"),
                  const Spacer(),
                  Text("${item.reps}"),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => editExercise(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteExercise(item),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
    return exerciseListView;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: createExerciseView(),
        ),
      ),
    );
  }
}

// Card(
// margin: EdgeInsets.zero,
// child: Padding(
// padding: const EdgeInsets.symmetric(
// horizontal: 20,
// vertical: 10,
// ),
// child: Row(
// children: [
// Column(
// children: [
// const Padding(
// padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
// child: Text(
// "Set",
// style: TextStyle(fontSize: 15),
// ),
// ),
// Text("${item.setNumber}"),
// ],
// ),
// const Spacer(),
// Column(
// children: [
// const Padding(
// padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
// child: Text(
// "Weight",
// style: TextStyle(fontSize: 15),
// ),
// ),
// Text("${item.weight}"),
// ],
// ),
// const Spacer(),
// Column(
// children: [
// const Padding(
// padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
// child: Text(
// "Rep",
// style: TextStyle(fontSize: 15),
// ),
// ),
// Text("${item.reps}"),
// ],
// ),
// const Spacer(),
// IconButton(
// icon: const Icon(Icons.edit),
// onPressed: () => deleteExercise(item),
// ),
// IconButton(
// icon: const Icon(Icons.delete),
// onPressed: () => deleteExercise(item),
// ),
// ],
// ),
// ),
// ),
