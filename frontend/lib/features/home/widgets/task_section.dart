import 'package:flutter/material.dart';


class TaskSection extends StatelessWidget {
  final String title;
  final Widget child;

  const TaskSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          title.toUpperCase(),

          style: TextStyle(
            color:
                Colors.white.withOpacity(.4),

            fontSize: 10,

            letterSpacing: 3,

            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 18),

        child,
      ],
    );
  }
}