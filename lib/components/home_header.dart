import 'package:flutter/material.dart';

class HomeHeader extends StatefulWidget {
  final int calorie;
  final double hourSpent;
  final int daysWorkout;
  const HomeHeader(
      {super.key,
      required this.calorie,
      required this.hourSpent,
      required this.daysWorkout});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
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
      child: Row(
        children: [
          Column(
            children: [
              Text(
                "${widget.calorie}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Calorie",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                "${widget.hourSpent}",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Hours",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                "${widget.daysWorkout}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Last 7 days",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
