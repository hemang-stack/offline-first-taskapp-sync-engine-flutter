import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/tasks/cubit/tasks_cubit.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

import '../widgets/curator_appbar.dart';
import '../widgets/empty_tasks.dart';
import '../widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthCubit>().state;

    if (authState is AuthLoggedIn) {
      context.read<TasksCubit>().getAllTasks(
            token: authState.user.token,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
          ),
          child: BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              if (state is TasksLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is TasksError) {
                return Center(
                  child: Text(
                    state.error,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }

              if (state is GetTaskSuccess) {
                final tasks = state.tasks;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    const CuratorAppbar(),
                    const SizedBox(height: 46),
                    const FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "good evening.",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${tasks.length} ITEMS AWAITING CURATION",
                      style: const TextStyle(
                        color: AppColors.primarySoft,
                        fontSize: 10,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Expanded(
                      child: tasks.isEmpty
                          ? const EmptyTasks()
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: tasks.length,
                              separatorBuilder: (_, __) => const SizedBox(
                                height: 18,
                              ),
                              itemBuilder: (context, index) {
                                final task = tasks[index];

                                return TaskCard(
                                  task: task,
                                  title: task.title,
                                  subtitle: task.priority.toUpperCase(),
                                  completed: task.isCompleted,
                                );
                              },
                            ),
                    ),
                  ],
                );
              }

              return const Center(
                child: Text(
                  "No State Found",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
