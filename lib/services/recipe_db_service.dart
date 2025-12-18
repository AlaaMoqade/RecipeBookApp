import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipy.dart';

class RecipeDBService {
  static Database? _db;

  static Future<void> init() async {
    if (_db != null) return;

    String path = join(await getDatabasesPath(), 'recipe_app.db');

    _db = await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS recipes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            image TEXT,
            rating REAL,
            ingredients TEXT,
            instructions TEXT,
            userEmail TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS recipes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            image TEXT,
            rating REAL,
            ingredients TEXT,
            instructions TEXT,
            userEmail TEXT
          )
        ''');
      },
    );

    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        image TEXT,
        rating REAL,
        ingredients TEXT,
        instructions TEXT,
        userEmail TEXT
      )
    ''');
  }

  static Future<int> insertRecipe(Recipe recipe) async {
    await init();
    return await _db!.insert('recipes', _recipeToMap(recipe));
  }

  static Future<List<Recipe>> getRecipesByUser(String userEmail) async {
    await init();
    final maps = await _db!.query(
      'recipes',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    );
    return maps.map((map) => _mapToRecipe(map)).toList();
  }

  static Future<int> updateRecipe(Recipe recipe) async {
    await init();
    return await _db!.update(
      'recipes',
      _recipeToMap(recipe),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  static Future<int> deleteRecipe(int id) async {
    await init();
    return await _db!.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Map<String, dynamic> _recipeToMap(Recipe r) {
    return {
      'name': r.name,
      'image': r.image,
      'rating': r.rating,
      'ingredients': r.ingredients.join('|'),
      'instructions': r.instructions.join('|'),
      'userEmail': r.userEmail,
    };
  }

  static Recipe _mapToRecipe(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      rating: map['rating'],
      ingredients: map['ingredients'] != null
          ? (map['ingredients'] as String).split('|')
          : [],
      instructions: map['instructions'] != null
          ? (map['instructions'] as String).split('|')
          : [],
      userEmail: map['userEmail'],
    );
  }
}
