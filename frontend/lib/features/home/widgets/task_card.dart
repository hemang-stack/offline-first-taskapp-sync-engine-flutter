import 'package:flutter/material.dart'; 
import 'package:frontend/features/tasks/pages/task_details_page.dart';
import 'package:frontend/models/task_model.dart';

import '../../tasks/widgets/shared/task_checkbox.dart';
import '../../../core/common/widgets/glass_container.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool completed;
  final TaskModel task;

  const TaskCard(
      {super.key,
      required this.title,
      required this.subtitle,
      this.completed = false,
      required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late bool completed;

  @override
  void initState() {
    super.initState();

    completed = widget.completed;
  }

  void toggleTask() {
    setState(() {
      completed = !completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailsPage(
              task: widget.task,
            ),
          ),
        );

        if (result == true) {
          setState(() {
            completed = true;
          });
        }
      },
      child: GlassContainer(
        borderRadius: AppRadius.lg,
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CHECKBOX
            TaskCheckbox(
              completed: completed,
              onTap: toggleTask,
            ),

            const SizedBox(width: 16),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      decoration: completed ? TextDecoration.lineThrough : null,
                      decorationColor: AppColors.primarySoft,
                      decorationThickness: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(.7),
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),

            /// MORE
            Icon(
              Icons.more_vert,
              color: Colors.white.withOpacity(.35),
            ),
          ],
        ),
      ),
    );
  }
}
