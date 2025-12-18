import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DBService {
  static Database? _db;

  static Future<void> init() async {
    if (_db != null) return;

    String path = join(await getDatabasesPath(), 'recipe_app.db');
    _db = await openDatabase(path);

    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,        
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  static Future<int> insertUser(User user) async {
    await init();
    return await _db!.insert('users', user.toMap());
  }

  static Future<User?> getUserByEmail(String email) async {
    await init();
    final List<Map<String, dynamic>> maps = await _db!.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
}
