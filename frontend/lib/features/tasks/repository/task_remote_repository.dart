import 'dart:convert';

import 'package:frontend/core/common/utils/constants.dart';
import 'package:frontend/features/tasks/repository/task_local_repository.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class TaskRemoteRepository {
  final taskLocalRepository = TaskLocalRepository();

  Future<TaskModel> createTask({
    required String title,
    required String description,
    required DateTime dueAt,
    required String priority,
    required String category,
    required bool isCompleted,
    required String token,
    required String uid,
  }) async {
    try {
      final res = await http.post(Uri.parse("${Constants.backendUri}/tasks"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
          body: jsonEncode(
            {
              'title': title,
              'description': description,
              'dueAt': dueAt.toIso8601String(),
              'priority': priority,
              'category': category,
              'isCompleted': isCompleted,
            },
          ));

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      final task = TaskModel.fromJson(res.body);

      await taskLocalRepository.insertTask(task);

      return task;
    } catch (e) {
      try {
        final taskModel = TaskModel(
            id: Uuid().v4(),
            uid: uid,
            title: title,
            description: description,
            priority: priority,
            category: category,
            isCompleted: isCompleted,
            dueAt: dueAt,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isSynced: 0);
        taskLocalRepository.insertTask(taskModel);
        return taskModel;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<TaskModel> updateTask({
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
      final res = await http.put(
        Uri.parse("${Constants.backendUri}/tasks/$taskId"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'priority': priority,
          'category': category,
          'dueAt': dueAt.toIso8601String(),
          'isCompleted': isCompleted,
        }),
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }

      final task = TaskModel.fromJson(res.body);

      await taskLocalRepository.updateTask(task);

      return task;
    } catch (_) {
      final localTask = await taskLocalRepository.getTaskById(taskId);

      if (localTask == null) {
        rethrow;
      }

      final updatedTask = localTask.copyWith(
        title: title,
        description: description,
        priority: priority,
        category: category,
        dueAt: dueAt,
        isCompleted: isCompleted,
        updatedAt: DateTime.now(),
      );

      await taskLocalRepository.updateTask(updatedTask);

      return updatedTask;
    }
  }

  Future<void> deleteTask({
    required String taskId,
    required String token,
  }) async {
    try {
      final res = await http.delete(
        Uri.parse("${Constants.backendUri}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'taskId': taskId,
        }),
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }

      await taskLocalRepository.deleteTask(taskId);
    } catch (_) {
    await taskLocalRepository.deleteTask(taskId);
  }
  }

  Future<List<TaskModel>> getTasks({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${Constants.backendUri}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      final List<dynamic> listOfTasks = jsonDecode(res.body);

      final tasks = listOfTasks
          .map(
            (e) => TaskModel.fromMap(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();

      await taskLocalRepository.insertTasks(tasks);

      return tasks;
    } catch (e) {
      final tasks = await taskLocalRepository.getTask();
      if (tasks.isNotEmpty) {
        return tasks;
      }
      rethrow;
    }
  }
}
