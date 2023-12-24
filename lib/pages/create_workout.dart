// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../components/create_workout_header.dart';
// import '../components/exercise_detail_tile.dart';
//
// class CreateWorkout extends StatefulWidget {
//   const CreateWorkout({super.key});
//
//   @override
//   State<CreateWorkout> createState() => _CreateWorkoutState();
// }
//
// class _CreateWorkoutState extends State<CreateWorkout> {
//   final newExerciseNameController = TextEditingController();
//   final newExerciseDescriptionController = TextEditingController();
//   final newExerciseWeightController = TextEditingController();
//   final newExerciseRepsController = TextEditingController();
//
//   void signOut() {
//     FirebaseAuth.instance.signOut();
//   }
//
//   // add new workout
//   void addNewWorkout() {
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: const Text("Add new Exercise"),
//               content: Column(mainAxisSize: MainAxisSize.min, children: [
//                 // Expense name
//                 TextField(
//                   controller: newExerciseNameController,
//                   decoration: const InputDecoration(hintText: "Exercise Name"),
//                 ),
//
//                 // expense amount
//
//                 TextField(
//                   controller: newExerciseDescriptionController,
//                   keyboardType: TextInputType.number,
//                   decoration:
//                       const InputDecoration(hintText: "Excercise Description"),
//                 ),
//               ]),
//               actions: [
//                 // save button
//                 MaterialButton(
//                   onPressed: () => {},
//                   child: const Text('Save'),
//                 ),
//                 // cancel button
//                 MaterialButton(
//                   onPressed: () => {},
//                   child: const Text('Cancel'),
//                 ),
//               ],
//             ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const Drawer(),
//       appBar: AppBar(
//           centerTitle: true,
//           title: const Text(
//             "Workout Tracker",
//             textAlign: TextAlign.center,
//           ),
//           actions: [
//             IconButton(
//                 onPressed: signOut,
//                 icon: const Icon(
//                   Icons.logout,
//                 )),
//           ]),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // for (var item in [1, 2, 3]) const HomeHeader(),
//               const CreateWorkoutHeader(),
//
//               // for (var item in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
//               for (var item in [1, 2, 3])
//                 ExerciseDetailTile(
//                   tileDetail: item,
//                   // onTap: () => print(item),
//                 ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: addNewWorkout,
//       ),
//     );
//     // floatingActionButton: SpeedDial(
//     //   icon: Icons.add,
//     //   children: [
//     //     SpeedDialChild(
//     //       label: 'Break',
//     //       child: const Icon(
//     //         Icons.free_breakfast,
//     //       ),
//     //     ),
//     //     SpeedDialChild(
//     //       label: 'Workout',
//     //       onTap: () => context.go('/create-workout'),
//     //       child: const Icon(
//     //         Icons.fitness_center,
//     //       ),
//     //     ),
//     //   ],
//     // ));
//   }
// }
