import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/workout.dart';
import '../state/workout_tracker_state.dart';
import 'create_workout_header.dart';

class WorkoutTile extends StatefulWidget {
  // final Function()? onTap;
  final List<Workout> workoutList;
  const WorkoutTile({
    super.key,
    required this.workoutList,
  });

  @override
  State<WorkoutTile> createState() => _WorkoutTileState();
}

class _WorkoutTileState extends State<WorkoutTile> {
  late var pState = Provider.of<WorkoutTrackerState>(context, listen: false);

  Text dateTimeFunc(DateTime date) {
    return Text(DateFormat('EEEE, dd-MM-yyyy hh:mm:ss').format(date));
  }

  void deleteWorkout(int workoutId) {
    pState.deleteWorkout(workoutId);
    Navigator.pop(context);
  }

  void deletePrompt(int workoutId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Are you sure ?",
          textAlign: TextAlign.center,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => deleteWorkout(workoutId),
              child: const Text("Yes"),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("cancel"),
            ),
          ],
        ),
      ),
    );
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
              itemCount: widget.workoutList.length,
              itemBuilder: (BuildContext context, int index) => Card(
                child: ListTile(
                  onTap: () => context.goNamed(
                    'exercise',
                    pathParameters: {
                      'workout_id': "${widget.workoutList[index].workoutId}"
                    },
                  ),
                  leading: const Icon(Icons.fitness_center),
                  title: Row(
                    children: [
                      SizedBox(
                        child: Text(widget.workoutList[index].workoutName),
                      ),
                      const Spacer(),
                      SizedBox(
                        child: Text(
                          "${widget.workoutList[index].totalWeightLifted}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle:
                      dateTimeFunc(widget.workoutList[index].lastWorkoutDate),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        deletePrompt(widget.workoutList[index].workoutId),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
