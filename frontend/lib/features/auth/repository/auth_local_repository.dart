import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:frontend/models/user_models.dart';

class AuthLocalRepository {
  final String tableName = "users";

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
    final path = join(dbPath, "auth.db");

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE $tableName(
  id TEXT PRIMARY KEY,
  email TEXT NOT NULL,
  name TEXT NOT NULL,
  token TEXT NOT NULL,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL
)
''');
      },
    );
  }

  Future<void> insertUser(UserModels userModel) async {
    final db = await database;

    await db.insert(
      tableName,
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModels?> getUser() async {
    final db = await database;

    final result = await db.query(
      tableName,
      limit: 1,
    );

    if (result.isNotEmpty) {
      return UserModels.fromMap(result.first);
    }

    return null;
  }

  Future<void> clearUser() async {
    final db = await database;

    await db.delete(tableName);
  }
}
