import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_sqflite/common/enums/category_enum.dart';
import 'package:todo_app_sqflite/common/utils/constants/db_constants.dart';
import 'package:todo_app_sqflite/common/utils/typdefs.dart';

class LocalDataSource {
  // singleton pattern
  static LocalDataSource instance = LocalDataSource._internal();

  // named constructor
  LocalDataSource._internal();

  // factory constructor
  factory LocalDataSource() => instance;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await initDB();
    return _db!;
  }

  // initialiaze db
  Future<Database> initDB() async {
    final dbPathInOs = await getDatabasesPath();
    final dbPath = join(dbPathInOs, "todo.db");

    final db = await openDatabase(
      version: 1,
      dbPath,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE ${DbConstants.todoTableName} (
          ${DbConstants.todoIdCol} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DbConstants.todoTitleCol} TEXT NOT NULL,
          ${DbConstants.todoDateCol} TEXT NOT NULL,
          ${DbConstants.todoCategoryCol} TEXT NOT NULL,
          ${DbConstants.todoStatusCol} INTEGER NOT NULL
        )
      ''');
      },
    );
    return db;
  }

  // get todos
  Future<List<DataMap>> getTodos() async {
    final db = await database;
    return await db.query(DbConstants.todoTableName);
  }

  // add todo
  Future<bool> addTodo({
    required String title,
    required String dateTime,
    required CategoryEnum category,
  }) async {
    final db = await database;
    try {
      final response = await db.insert(
        DbConstants.todoTableName,
        {
          DbConstants.todoTitleCol: title,
          DbConstants.todoDateCol: dateTime,
          DbConstants.todoCategoryCol: category.name,
          DbConstants.todoStatusCol: 0,
        },
      );
      if (response != 0) {
        return true;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return false;
  }

// update todo
  Future<bool> updateTodo({
    required int id,
    required String title,
    required String dateTime,
  }) async {
    final db = await database;
    try {
      final response = await db.update(
        DbConstants.todoTableName,
        {
          DbConstants.todoTitleCol: title,
          DbConstants.todoDateCol: dateTime,
        },
        where: "id=?",
        whereArgs: [id],
      );
      if (response != 0) {
        return true;
      }
    } catch (e) {
      log("Error happened while updating todo: $e");
      throw Exception(e.toString());
    }
    return false;
  }

// delete todo
  Future<void> deleteTodo(int id) async {
    final db = await database;
    await db.delete(
      DbConstants.todoTableName,
      where: "id=?",
      whereArgs: [id],
    );
  }
}
