part of 'tasks_cubit.dart';

sealed class TasksState {
  const TasksState();
}

final class TasksInitial extends TasksState {
  const TasksInitial();
}

final class TasksLoading extends TasksState {
  const TasksLoading();
}

final class TasksError extends TasksState {
  final String error;

  const TasksError(this.error);
}

final class GetTaskSuccess extends TasksState {
  final List<TaskModel> tasks;

  const GetTaskSuccess(this.tasks);
}

final class DeleteTaskSuccess extends TasksState {
  const DeleteTaskSuccess();
}
