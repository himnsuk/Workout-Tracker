import 'package:flutter/material.dart';

class CreateWorkoutHeader extends StatelessWidget {
  const CreateWorkoutHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.fromLTRB(
        30,
        30,
        30,
        10,
      ),
      width: double.infinity,
      child: const Center(
        child: Text(
          'Workout List',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
