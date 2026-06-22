import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/tasks/cubit/add_new_task_cubit.dart';
import 'package:frontend/features/tasks/models/task_UI_model.dart';
import 'package:frontend/features/tasks/repository/task_remote_repository.dart';
import 'package:frontend/models/task_model.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(const TasksInitial()){
    print("TASKS CUBIT CREATED");
  }

  final taskRemoteRepository = TaskRemoteRepository();

  Future<void> createNewTask({
    required String title,
    String? description,
    required TaskPriority priority,
    required DateTime scheduledAt,
    String? category,
    required bool isCompleted,
    required String token,
  }) async {
    try {
      emit(const TasksLoading());

      final task = await taskRemoteRepository.createTask(
        title: title,
        description: description ?? '',
        dueAt: scheduledAt,
        priority: priority.name,
        category: category ?? '',
        isCompleted: isCompleted,
        token: token,
      );

    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> getAllTasks({
    required String token,
  }) async {

    emit(TasksLoading());

    final tasks = await taskRemoteRepository.getTasks(
      token: token,
    );

    emit(GetTaskSuccess(tasks));
  }
}
