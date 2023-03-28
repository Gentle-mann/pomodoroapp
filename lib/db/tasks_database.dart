import 'dart:core';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/models/task.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();

  TasksDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasksr.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    final db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $taskTable (
    ${TaskFields.id} $idType,
    ${TaskFields.title} $textType,
    ${TaskFields.focusTime} $integerType,
    ${TaskFields.breakTime} $integerType,
    ${TaskFields.createdTime} $textType,
    ${TaskFields.loops} $textType
    )
    ''');
  }

  Future<void> create(Task task) async {
    final db = await instance.database;
    await db.insert(taskTable, task.toJson());
  }

  Future<Task> readTask(int id) async {
    final db = await instance.database;
    final tasks = await db.query(
      taskTable,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
    if (tasks.isNotEmpty) {
      return Task.fromJson(tasks.first);
    } else {
      throw Exception('ID $id Not Found');
    }
  }

  Future<List<Task>> readAllTask() async {
    const orderBy = '${TaskFields.createdTime} DESC';
    final db = await instance.database;
    final resultJson = await db.query(taskTable, orderBy: orderBy);
    final resultList = resultJson.map((json) => Task.fromJson(json)).toList();
    return resultList;
  }

  Future<int> update(Task task) async {
    final db = await instance.database;
    final id = await db.update(taskTable, task.toJson(),
        where: '${TaskFields.id} = ?', whereArgs: [task.id]);
    return id;
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    final deletedTaskId = db.delete(
      taskTable,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
    return deletedTaskId;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
