import 'dart:convert';

import 'package:frontend/core/common/utils/constants.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskRemoteRepository {
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required DateTime dueAt,
    required String priority,
    required String category,
    required bool isCompleted,
    required String token,
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

      return TaskModel.fromJson(res.body);
    } catch (e) {
      rethrow;
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

      return listOfTasks
          .map(
            (e) => TaskModel.fromMap(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
