import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperR {
  static final DatabaseHelperR _instance = DatabaseHelperR._internal();
  factory DatabaseHelperR() => _instance;
  DatabaseHelperR._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'app_databaseR.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE dateDataR (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dateId TEXT,
            dateSubId TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertOrUpdateUser(Map<String, dynamic> user,String id,String subId) async {
    final db = await database;

    // まず既存データがあるか確認
    final existing = await db.query(
      'dateDataR',
      where: 'dateId = ? AND dateSubId = ?',
      whereArgs: [id,subId],
    );

    if (existing.isNotEmpty) {
      // 既存データがあれば更新
      return await db.update(
        'dateDataR',
        user,
        where: 'dateId = ? AND dateSubId = ?', // WHERE で特定の行を指定
        whereArgs: [id,subId],
      );
    } else {
      // データがなければ挿入
      return await db.insert('dateDataR', user);
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('dateDataR');
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update('dateDataR', user, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(String id,String index) async {
    final db = await database;
    return await db.delete('dateDataR', where: 'dateId = ? AND dateSubId = ?', whereArgs: [id,index]);
  }

  Future<int> allDelete(String id)async{
    final db = await database;
    return await db.delete('dateDataR', where: 'dateId = ?', whereArgs: [id]);
  }


  Future<List<Map<String, dynamic>>> getDuplicateCounts() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT date, COUNT(*) as count 
    FROM dateDataR 
    GROUP BY date
    HAVING COUNT(*) > 1
  ''');
  }

  Future<List<Map<String, dynamic>>> getDuplicatesAndNonDuplicates() async {
    final db = await database;

    // 重複しているデータと重複していないデータを両方取得するクエリ
    final result = await db.rawQuery('''
    SELECT date, COUNT(date) as count
    FROM dateDataR
    GROUP BY date
  ''');

    return result;
  }

  Future<List<Map<String, dynamic>>> getNonDuplicates() async {
    final db = await database;

    // 重複していないデータのみを取得するクエリ
    final result = await db.rawQuery('''
    SELECT date
    FROM dateDataR
    GROUP BY date
    HAVING COUNT(date) = 1
  ''');

    return result;
  }

}
