import 'package:flutter/foundation.dart';
import 'package:sqflite_common/sqflite.dart';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;
  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('employee.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWasm || kIsWeb) {
      var factory = databaseFactoryFfiWeb;
      return factory.openDatabase(inMemoryDatabasePath, options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDB,
      ));
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        role TEXT,
        startDate TEXT,
        endDate TEXT
      )
    ''');
  }
}
