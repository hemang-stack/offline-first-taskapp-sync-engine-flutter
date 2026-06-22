import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/tasks/cubit/tasks_cubit.dart';
import 'package:frontend/features/tasks/pages/create_task_page.dart';
import 'package:frontend/models/task_model.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class TaskDetailsPage extends StatefulWidget {
  final TaskModel task;

  const TaskDetailsPage({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  Future<void> deleteTask() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    await context.read<TasksCubit>().deleteTask(
          taskId: widget.task.id,
          token: user.user.token,
        );
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is DeleteTaskSuccess) {
          final user = context.read<AuthCubit>().state as AuthLoggedIn;

          context.read<TasksCubit>().getAllTasks(
                token: user.user.token,
              );

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Task deleted",
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: 20,
                ),
                children: [
                  /// HEADER
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "curator",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// TITLE
                  Text(
                    widget.task.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// PRIORITY LABEL
                  Text(
                    widget.task.priority.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 36),

                  /// HERO IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      "https://images.unsplash.com/photo-1511818966892-d7d671e672a2",
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// PRIORITY
                  _card(
                    title: "priority",
                    value: widget.task.priority.toUpperCase(),
                  ),

                  const SizedBox(height: 20),

                  /// CATEGORY
                  _card(
                    title: "category",
                    value: widget.task.category ?? "uncategorized",
                  ),

                  const SizedBox(height: 20),

                  /// DUE DATE
                  _card(
                    title: "due date",
                    value: formatDate(
                      widget.task.dueAt,
                    ),
                  ),

                  const SizedBox(height: 36),

                  /// DESCRIPTION LABEL
                  Text(
                    "DESCRIPTION",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.4),
                      letterSpacing: 4,
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  Text(
                    widget.task.description ?? "No description available.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.8),
                      height: 1.8,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 220),
                ],
              ),

              /// EDIT BUTTON
              Positioned(
                right: 24,
                bottom: 120,
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(.08),
                    border: Border.all(
                      color: Colors.white10,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateTaskPage(
                            isEdit: true,
                            task: widget.task,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              /// MARK AS DONE
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: Row(
                  children: [
                    /// DELETE BUTTON
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 72,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange.withOpacity(.9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          onPressed: deleteTask,
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// MARK AS DONE BUTTON
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 72,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(
                              context,
                              true,
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "mark as done",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(
                                Icons.check_circle,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(.4),
              letterSpacing: 4,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
