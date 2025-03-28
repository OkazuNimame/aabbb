import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE dateData (
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
      'dateData',
      where: 'dateId = ? AND dateSubId = ?',
      whereArgs: [id,subId],
    );

    if (existing.isNotEmpty) {
      // 既存データがあれば更新
      return await db.update(
        'dateData',
        user,
        where: 'dateId = ? AND dateSubId = ?', // WHERE で特定の行を指定
        whereArgs: [id,subId],
      );
    } else {
      // データがなければ挿入
      return await db.insert('dateData', user);
    }
  }


  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('dateData');
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update('dateData', user, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(String id,String index) async {
    final db = await database;
    return await db.delete('dateData', where: 'dateId = ? AND dateSubId = ?', whereArgs: [id,index]);
  }

  Future<int> allDelete(String id)async{
    final db = await database;
    return await db.delete('dateData', where: 'dateId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getDuplicateCounts() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT date, COUNT(*) as count 
    FROM dateData 
    GROUP BY date
    HAVING COUNT(*) > 1
  ''');
  }

  Future<List<Map<String, dynamic>>> getNonDuplicates() async {
    final db = await database;

    // 重複していないデータのみを取得するクエリ
    final result = await db.rawQuery('''
    SELECT date
    FROM dateData
    GROUP BY date
    HAVING COUNT(date) = 1
  ''');

    return result;
  }



}
