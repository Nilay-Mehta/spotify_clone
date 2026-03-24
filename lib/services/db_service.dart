import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'spotify_clone.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            artist TEXT NOT NULL,
            url TEXT NOT NULL,
            UNIQUE(title, artist)
          )
        ''');
      },
    );
  }

  // ---- User Authentication ----

  static Future<bool> registerUser(String username, String password) async {
    final db = await database;
    try {
      await db.insert('users', {
        'username': username,
        'password': password,
      });
      return true;
    } catch (e) {
      return false; // username already exists
    }
  }

  static Future<bool> loginUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  // ---- Favorites ----

  static Future<bool> insertFavorite(String title, String artist, String url) async {
    final db = await database;
    try {
      await db.insert('favorites', {
        'title': title,
        'artist': artist,
        'url': url,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> removeFavorite(String title, String artist) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'title = ? AND artist = ?',
      whereArgs: [title, artist],
    );
  }

  static Future<bool> isFavorite(String title, String artist) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'title = ? AND artist = ?',
      whereArgs: [title, artist],
    );
    return result.isNotEmpty;
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorites');
  }
}
