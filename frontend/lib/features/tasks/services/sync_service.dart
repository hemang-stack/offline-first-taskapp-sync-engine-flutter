import 'package:frontend/features/tasks/repository/task_local_repository.dart';
import 'package:frontend/features/tasks/repository/task_remote_repository.dart';

class SyncService {
  final TaskLocalRepository _localRepository =
      TaskLocalRepository();

  final TaskRemoteRepository _remoteRepository =
      TaskRemoteRepository();

  Future<void> syncTasks({
    required String token,
  }) async {
    final pendingTasks =
        await _localRepository.getPendingTasks();

    if (pendingTasks.isEmpty) {
      return;
    }

    for (final task in pendingTasks) {
      try {
        switch (task.syncStatus) {

          case "pending_create":

            final serverTask =
                await _remoteRepository.syncCreateTask(
              task: task,
              token: token,
            );

            // remove local pending task
            await _localRepository
                .permanentlyDeleteTask(task.id);

            // insert server version
            await _localRepository
                .insertTask(serverTask);

            break;

          case "pending_update":

            await _remoteRepository.syncUpdateTask(
              task: task,
              token: token,
            );

            await _localRepository.updateSyncStatus(
              taskId: task.id,
              syncStatus: "synced",
            );

            break;

          case "pending_delete":

            await _remoteRepository.syncDeleteTask(
              taskId: task.id,
              token: token,
            );

            await _localRepository
                .permanentlyDeleteTask(task.id);

            break;
        }
      } catch (_) {
        // Leave pending.
        // Retry next launch.
      }
    }
  }
}