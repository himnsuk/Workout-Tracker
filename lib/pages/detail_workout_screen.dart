// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:go_router/go_router.dart';
// import 'package:workout_tracker/components/workout_description_header.dart';
//
// import '../components/exercise_detail_tile.dart';
//
// class DetailWorkoutScreen extends StatefulWidget {
//   const DetailWorkoutScreen({super.key});
//
//   @override
//   State<DetailWorkoutScreen> createState() => _DetailWorkoutScreenState();
// }
//
// class _DetailWorkoutScreenState extends State<DetailWorkoutScreen> {
//   final user = FirebaseAuth.instance.currentUser!;
//   static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];
//   void signOut() {
//     FirebaseAuth.instance.signOut();
//   }
//
//   void _showAction(BuildContext context, int index) {
//     showDialog<void>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: Text(_actionTitles[index]),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('CLOSE'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: const Drawer(),
//         appBar: AppBar(
//             centerTitle: true,
//             title: const Text(
//               "Workout Tracker",
//               textAlign: TextAlign.center,
//             ),
//             actions: [
//               IconButton(
//                   onPressed: signOut,
//                   icon: const Icon(
//                     Icons.logout,
//                   )),
//             ]),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // for (var item in [1, 2, 3]) const HomeHeader(),
//                 const WorkoutDescriptionHeader(
//                   calorie: 54,
//                   daysWorkout: 3,
//                   hourSpent: 6,
//                   workoutName: "Abs Workout",
//                   workoutDescription: "Abs workout for core building",
//                 ),
//
//                 // for (var item in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
//                 for (var item in [1, 2, 3])
//                   ExerciseDetailTile(
//                     tileDetail: item,
//                     // onTap: () => print(item),
//                   ),
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: SpeedDial(
//           icon: Icons.add,
//           children: [
//             SpeedDialChild(
//               label: 'Break',
//               child: const Icon(
//                 Icons.free_breakfast,
//               ),
//             ),
//             SpeedDialChild(
//               label: 'Workout',
//               onTap: () => context.go('/create-workout'),
//               child: const Icon(
//                 Icons.fitness_center,
//               ),
//             ),
//             SpeedDialChild(
//               label: 'Excercise',
//               onTap: () => context.go('/create-excercise'),
//               child: const Icon(
//                 Icons.accessibility,
//               ),
//             ),
//           ],
//         ));
//   }
// }
