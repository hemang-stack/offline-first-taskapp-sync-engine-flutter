import 'package:frontend/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalRepository {
  final tableName = "tasks";

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "tasks.db");
    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) {
        return db.execute('''
CREATE TABLE $tableName(
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  dueAt int NOT NULL,
  uid TEXT NOT NULL,
  priority TEXT NOT NULL,
  category TEXT NOT NULL,
  isCompleted INTEGER NOT NULL,
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL,
  syncStatus TEXT NOT NULL
)
''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await db.execute(
            '''
ALTER TABLE $tableName
ADD COLUMN syncStatus TEXT NOT NULL DEFAULT 'synced'
''',
          );
        }
      },
    );
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert(tableName, task.toMap());
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<TaskModel>> getTask() async {
    final db = await database;

    final result = await db.query(
      tableName,
      where: "syncStatus != ?",
      whereArgs: ["pending_delete"],
    );

    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await database;

    await db.update(
      tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> markTaskForDeletion(String id) async {
    final db = await database;

    await db.update(
      tableName,
      {
        'syncStatus': 'pending_delete',
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    await getTaskById(id);
  }

  Future<void> permanentlyDeleteTask(String id) async {
    final db = await database;

    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TaskModel>> getPendingTasks() async {
    final db = await database;

    final result = await db.query(
      tableName,
      where: "syncStatus != ?",
      whereArgs: ['synced'],
    );

    return result
        .map(
          (e) => TaskModel.fromMap(e),
        )
        .toList();
  }

  Future<void> updateSyncStatus({
    required String taskId,
    required String syncStatus,
  }) async {
    final db = await database;

    await db.update(
      tableName,
      {
        'syncStatus': syncStatus,
      },
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<TaskModel?> getTaskById(String id) async {
    final db = await database;

    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return TaskModel.fromMap(result.first);
    }

    return null;
  }
}
