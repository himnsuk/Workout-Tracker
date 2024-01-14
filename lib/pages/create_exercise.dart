import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/exercise.dart';
import '../model/set_rep_weight_form_controller.dart';
import '../model/workout.dart';
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
  late Workout workout = pState.workoutList
      .firstWhere((element) => element.workoutId == intWorkoutId);
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
    if (_formKey.currentState!.validate()) {
      double totalWeightLifted = workout.totalWeightLifted;
      List<Exercise> exerciseList = [];
      for (var i = 0; i < setRepWeights.length; i++) {
        double doubleWeight = double.parse(setRepWeights[i].weight.text);
        int repsPerform = int.parse(setRepWeights[i].rep.text);
        totalWeightLifted += doubleWeight * repsPerform;
        exerciseList.add(Exercise(
          exerciseId: 1,
          workoutId: intWorkoutId,
          exerciseOrder: 1,
          exerciseName: newExerciseNameController.text,
          bodyPart: newExerciseBodyPartController.text,
          exerciseDescription: newExerciseDescriptionController.text,
          status: "created",
          setNumber: i + 1,
          weight: doubleWeight,
          reps: repsPerform,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      }
      pState.addNewExercises(intWorkoutId, exerciseList, totalWeightLifted);
      GoRouter.of(context).goNamed(
        "exercise",
        pathParameters: {"workoutId": "$intWorkoutId"},
      );
      // Navigator.pop(context);
      clearControls();
    }
  }

  // Update Weight
  void updateWeight(String updateType, TextEditingController ctrlWeight) {
    double weight = double.parse(ctrlWeight.text);
    setState(() {
      if (updateType == 'increase') {
        if (weight == 1.0) {
          weight += 1.5;
        } else {
          weight += 2.5;
        }
      } else if (weight > 2.5) {
        weight -= 2.5;
      }
      ctrlWeight.text = weight.toString();
    });
  }

  // Update Reps
  void updateReps(String updateType, TextEditingController ctrlReps) {
    int reps = int.parse(ctrlReps.text);
    setState(() {
      if (updateType == 'increase') {
        reps += 1;
      } else if (reps > 1) {
        reps -= 1;
      }
      ctrlReps.text = reps.toString();
    });
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutTrackerState>(
      builder: (builder, value, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "Workout Tracker",
            textAlign: TextAlign.center,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Body Part
              DropdownButton<String>(
                isExpanded: true,
                value: newExerciseBodyPartController.text,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.blueAccent),
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    newExerciseBodyPartController.text = value!;
                  });
                },
                items:
                    bodyPartList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Exercise name
              TextFormField(
                controller: newExerciseNameController,
                decoration: const InputDecoration(hintText: "Exercise Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter exercise name';
                  }
                  return null;
                },
              ),

              // Exercise Description

              TextFormField(
                controller: newExerciseDescriptionController,
                decoration:
                    const InputDecoration(hintText: "Exercise Description"),
              ),
              ElevatedButton(
                  onPressed: addNewSet, child: const Text("Add Set")),
              Expanded(
                child: ListView.builder(
                    itemCount: setRepWeights.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Set - ${index + 1}",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Weight"),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_rounded,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () => updateWeight(
                                    "decrease", setRepWeights[index].weight),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: setRepWeights[index].weight,
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      const InputDecoration(hintText: "1.0"),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        double.parse(value) == 0.0 ||
                                        double.parse(value) == 0) {
                                      return 'Please enter valid weight';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_rounded,
                                    color: Colors.blueAccent),
                                onPressed: () => updateWeight(
                                    "increase", setRepWeights[index].weight),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Reps"),
                              const SizedBox(
                                width: 23,
                              ),
                              IconButton(
                                onPressed: () => updateReps(
                                    "decrease", setRepWeights[index].rep),
                                icon: const Icon(Icons.remove_circle_rounded,
                                    color: Colors.blueAccent),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: setRepWeights[index].rep,
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      const InputDecoration(hintText: "1"),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        int.parse(value) == 0) {
                                      return 'Please enter valid weight';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () => updateReps(
                                    "increase", setRepWeights[index].rep),
                                icon: const Icon(Icons.add_circle_rounded,
                                    color: Colors.blueAccent),
                              ),
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
      ),
    );
  }
}
