import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bitoo_food.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        await db.execute('''
          CREATE TABLE Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullName TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE, 
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }


  Future<bool> checkEmailExists(String email) async {
    final db = await database;
    final result = await db.query('Users', where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty;
  }

  Future<int> registerUser(User user) async {
    final db = await database;
    return await db.insert('Users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
        'Users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password]
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;

    List<Map<String, dynamic>> res = await db.query(
      "Users",
      where: "email = ?",
      whereArgs: [email],
    );

    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }


  Future<int> updateUserInfo(String currentEmail, String newName, String newEmail, String newPassword) async {
    final db = await database;

    Map<String, dynamic> newValues = {
      'fullName': newName,
      'email': newEmail,
      'password': newPassword,
    };


    return await db.update(
      "Users",
      newValues,
      where: "email = ?",
      whereArgs: [currentEmail],
    );
  }


  Future<int> updatePassword(String email, String newPassword) async {
    final db = await database;
    return await db.update(
      'Users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<int> deleteUser(String email) async {
    final db = await database;
    return await db.delete(
      'Users', // Tên bảng
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}