import 'package:flutter/material.dart';

class CreateExercisePopup extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController? descriptionController;
  final TextEditingController? weightController;
  final TextEditingController? repsController;
  final Function()? save;
  final Function()? cancel;

  const CreateExercisePopup(
      {super.key,
      required this.nameController,
      required this.descriptionController,
      required this.weightController,
      required this.repsController,
      required this.save,
      required this.cancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new Exercise"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        // Expense name
        TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Exercise Name"),
        ),

        // expense amount

        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(hintText: "Excercise Description"),
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
                controller: weightController,
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
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "1"),
              ),
            ),
            const Icon(Icons.remove_circle_rounded)
          ],
        ),
      ]),
      actions: [
        // save button
        MaterialButton(
          onPressed: save,
          child: const Text('Save'),
        ),
        // cancel button
        MaterialButton(
          onPressed: cancel,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
