import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/tasks/repository/task_remote_repository.dart';
import 'package:frontend/models/task_model.dart';

part 'add_new_task_state.dart';

class AddNewTaskCubit extends Cubit<AddNewTaskState> {
  AddNewTaskCubit()
      : super(const AddNewTaskInitial());

  final taskRemoteRepository =
      TaskRemoteRepository();

  Future<void> createNewTask({
    required String title,
    required String description,
    required DateTime dueAt,
    required String priority,
    required String category,
    required bool isCompleted,
    required String token,
  }) async {
    try {

      emit(
        const AddNewTaskLoading(),
      );

      final task =
          await taskRemoteRepository
              .createTask(
        title: title,
        description: description,
        dueAt: dueAt,
        priority: priority,
        category: category,
        isCompleted: isCompleted,
        token: token,
      );

      emit(
        AddNewTaskSuccess(task),
      );
    } catch (e) { 
      emit(
        AddNewTaskError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updateTask({
    required String taskId,
    required String title,
    required String description,
    required DateTime dueAt,
    required String priority,
    required String category,
    required bool isCompleted,
    required String token,
  }) async {
    try {
      emit(
        const AddNewTaskLoading(),
      );

      final task =
          await taskRemoteRepository
              .updateTask(
        taskId: taskId,
        title: title,
        description: description,
        dueAt: dueAt,
        priority: priority,
        category: category,
        isCompleted: isCompleted,
        token: token,
      );

      emit(
        UpdateTaskSuccess(task),
      );
    } catch (e) {
      emit(
        AddNewTaskError(
          e.toString(),
        ),
      );
    }
  }
}