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

    // We'll implement this next
  }
}