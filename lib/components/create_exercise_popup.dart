import 'package:flutter/material.dart';
import 'package:workout_tracker/model/set_rep_weight_form_controller.dart';

class CreateExercisePopup extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController? descriptionController;
  final TextEditingController? bodyPartController;
  final List<SetRepWeightFormController> setRepWeightFormController;
  final List<String> bodyPartList;
  final Function()? saveFunc;
  final Function()? cancelFunc;
  final Function()? addNewSet;

  const CreateExercisePopup({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.bodyPartController,
    required this.bodyPartList,
    required this.saveFunc,
    required this.cancelFunc,
    required this.addNewSet,
    required this.setRepWeightFormController,
  });

  @override
  State<CreateExercisePopup> createState() => _CreateExercisePopupState();
}

class _CreateExercisePopupState extends State<CreateExercisePopup> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AlertDialog(
        title: const Text("Add new Exercise"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          // Body Part
          DropdownButton<String>(
            isExpanded: true,
            value: widget.bodyPartController?.text,
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
                widget.bodyPartController?.text = value!;
              });
            },
            items: widget.bodyPartList
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // Exercise name
          TextField(
            controller: widget.nameController,
            decoration: const InputDecoration(hintText: "Exercise Name"),
          ),

          // expense amount

          TextField(
            controller: widget.descriptionController,
            decoration:
                const InputDecoration(hintText: "Excercise Description"),
          ),
          ElevatedButton(onPressed: widget.addNewSet, child: Text("Add Set")),
          for (int i = 0; i < widget.setRepWeightFormController.length; i++)
            Column(
              children: [
                Row(
                  children: [Text("Set - ${i + 1}")],
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
                        controller: widget.setRepWeightFormController[i].weight,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: "1.0"),
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
                        controller: widget.setRepWeightFormController[i].rep,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: "1"),
                      ),
                    ),
                    const Icon(Icons.remove_circle_rounded)
                  ],
                ),
              ],
            ),
        ]),
        actions: [
          // save button
          MaterialButton(
            onPressed: widget.saveFunc,
            child: const Text('Save'),
          ),
          // cancel button
          MaterialButton(
            onPressed: widget.cancelFunc,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
