import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/workout.dart';
import 'create_workout_header.dart';

class WorkoutTile extends StatelessWidget {
  // final Function()? onTap;
  final List<Workout> workoutList;
  const WorkoutTile({
    super.key,
    required this.workoutList,
  });

  Text dateTimeFunc(DateTime date) {
    var dtString = "${date.day}/${date.month}/${date.year}";
    return Text(dtString);
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
              itemCount: workoutList.length,
              itemBuilder: (BuildContext context, int index) => Card(
                child: ListTile(
                  onTap: () => context.pushNamed(
                    'add-exercise',
                    pathParameters: {
                      'workout_id': "${workoutList[index].workoutId}"
                    },
                  ),
                  leading: const Icon(Icons.fitness_center),
                  title: Row(
                    children: [
                      SizedBox(
                        child: Text(workoutList[index].workoutName),
                      ),
                      const Spacer(),
                      SizedBox(
                        child: Text(
                          "${workoutList[index].totalWeightLifted}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: dateTimeFunc(workoutList[index].lastWorkoutDate),
                  trailing: const Icon(Icons.delete),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
