import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/tasks/models/task_UI_model.dart';
import 'package:frontend/features/tasks/repository/task_local_repository.dart';
import 'package:frontend/features/tasks/repository/task_remote_repository.dart';
import 'package:frontend/features/tasks/services/sync_service.dart';
import 'package:frontend/models/task_model.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(const TasksInitial());

  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();
  final syncService = SyncService();

  Future<void> createNewTask({
    required String title,
    String? description,
    required TaskPriority priority,
    required DateTime scheduledAt,
    String? category,
    required bool isCompleted,
    required String token,
    required String uid,
  }) async {
    try {
      emit(const TasksLoading());

      final task = await taskRemoteRepository.createTask(
        uid: uid,
        title: title,
        description: description ?? '',
        dueAt: scheduledAt,
        priority: priority.name,
        category: category ?? '',
        isCompleted: isCompleted,
        token: token,
      );
      await taskLocalRepository.insertTask(task);
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> deleteTask({
    required String taskId,
    required String token,
  }) async {
    try {
      emit(
        const TasksLoading(),
      );

      await taskRemoteRepository.deleteTask(
        taskId: taskId,
        token: token,
      );

      emit(
        const DeleteTaskSuccess(),
      );
    } catch (e) {
      emit(
        TasksError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> getAllTasks({
    required String token,
  }) async {
    emit(TasksLoading());

    await syncService.syncTasks(
      token: token,
    );

    final tasks = await taskRemoteRepository.getTasks(
      token: token,
    );

    emit(GetTaskSuccess(tasks));
  }
}
