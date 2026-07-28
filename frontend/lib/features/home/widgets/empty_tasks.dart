import 'package:flutter/material.dart';


class EmptyTasks extends StatelessWidget {
  const EmptyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            Icons.auto_awesome,
            size: 42,
            color:
                Colors.white.withOpacity(.12),
          ),

          const SizedBox(height: 20),

          const Text(
            "nothing to curate.",

            style: TextStyle(
              color: Colors.white38,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "create your first task",

            style: TextStyle(
              color:
                  Colors.white.withOpacity(.2),

              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}