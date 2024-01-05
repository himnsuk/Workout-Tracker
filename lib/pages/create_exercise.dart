import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/exercise.dart';
import '../model/set_rep_weight_form_controller.dart';
import '../state/workout_tracker_state.dart';

class CreateExercise extends StatefulWidget {
  final String? workoutId;

  const CreateExercise({
    super.key,
    required this.workoutId,
  });

  @override
  State<CreateExercise> createState() => _CreateExerciseState();
}

class _CreateExerciseState extends State<CreateExercise> {
  final newExerciseNameController = TextEditingController();
  final newExerciseDescriptionController = TextEditingController();
  final newExerciseBodyPartController = TextEditingController(text: "CHEST");
  final List<SetRepWeightFormController> setRepWeights = [
    SetRepWeightFormController(
        set: TextEditingController(),
        weight: TextEditingController(text: "1.0"),
        rep: TextEditingController(text: "1"))
  ];
  late int intWorkoutId = int.parse(widget.workoutId.toString());
  late var pState = Provider.of<WorkoutTrackerState>(context, listen: false);
  late List<String> bodyPartList = pState.bodyPartList;
  // final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pState.fetchAllExerciseForWorkout(intWorkoutId);
  }

  void addNewSet() {
    setState(() {
      setRepWeights.add(SetRepWeightFormController(
          set: TextEditingController(),
          weight: TextEditingController(text: "1.0"),
          rep: TextEditingController(text: "1")));
    });
  }

  // save
  void save() {
    List<Exercise> exerciseList = [];
    for (var i = 0; i < setRepWeights.length; i++) {
      exerciseList.add(Exercise(
        exerciseId: 1,
        workoutId: intWorkoutId,
        exerciseOrder: 1,
        exerciseName: newExerciseNameController.text,
        bodyPart: newExerciseBodyPartController.text,
        exerciseDescription: newExerciseDescriptionController.text,
        status: "created",
        setNumber: i + 1,
        weight: double.parse(setRepWeights[i].weight.text),
        reps: int.parse(setRepWeights[i].rep.text),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
    pState.addNewExercises(intWorkoutId, exerciseList);
    GoRouter.of(context).pop();
    // Navigator.pop(context);
    clearControls();
  }

  // cancel
  void cancel() {
    GoRouter.of(context).pop();
    // Navigator.pop(context);
    clearControls();
  }

  // clear controllers
  void clearControls() {
    newExerciseNameController.clear();
    newExerciseDescriptionController.clear();
    setRepWeights.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutTrackerState>(
      builder: (builder, value, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Workout Tracker",
              textAlign: TextAlign.center,
            ),
            actions: const [
              Icon(Icons.logout),
            ]),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Body Part
            DropdownButton<String>(
              isExpanded: true,
              value: newExerciseBodyPartController.text,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  newExerciseBodyPartController.text = value!;
                });
              },
              items: bodyPartList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // Exercise name
            TextField(
              controller: newExerciseNameController,
              decoration: const InputDecoration(hintText: "Exercise Name"),
            ),

            // Exercise Description

            TextField(
              controller: newExerciseDescriptionController,
              decoration:
                  const InputDecoration(hintText: "Exercise Description"),
            ),
            ElevatedButton(onPressed: addNewSet, child: const Text("Add Set")),
            Expanded(
              child: ListView.builder(
                  itemCount: setRepWeights.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Row(
                          children: [Text("Set - ${index + 1}")],
                        ),
                        Row(
                          children: [
                            const Text("Weight"),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.add_circle_rounded),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: setRepWeights[index].weight,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(hintText: "1.0"),
                              ),
                            ),
                            const Icon(Icons.remove_circle_rounded)
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Reps"),
                            const SizedBox(
                              width: 25,
                            ),
                            const Icon(Icons.add_circle_rounded),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: setRepWeights[index].rep,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(hintText: "1"),
                              ),
                            ),
                            const Icon(Icons.remove_circle_rounded)
                          ],
                        ),
                      ],
                    );
                  }),
            ),
            Row(
              children: [
                // save button
                ElevatedButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
                // cancel button
                const Spacer(),
                ElevatedButton(
                  onPressed: cancel,
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
