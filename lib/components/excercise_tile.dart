import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExcerciseTile extends StatelessWidget {
  final int tileDetail;
  // final Function()? onTap;
  const ExcerciseTile({
    super.key,
    required this.tileDetail,
    // required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () => context.go('/workout-details'),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.all(5),
        child: Row(
          children: [
            const Icon(Icons.arrow_right_outlined),
            const SizedBox(
              width: 30,
            ),
            Column(
              children: [
                Text("Item $tileDetail"),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Item $tileDetail",
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
