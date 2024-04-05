import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabaseHelper {
  
  static const String tableName = 'users';
  static const String columnId = 'id';
  static const String columnFirstName = 'first_name';
  static const String columnLastName = 'last_name';
  static const String columnEmail = 'email';
  static const String columnAvatar = 'avatar';

  // Singleton instance
  UserDatabaseHelper._privateConstructor();
  static final UserDatabaseHelper instance = UserDatabaseHelper._privateConstructor();

  // Database reference
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!; // Return existing database if available
    _database = await _initDatabase(); // Lazily instantiate the database
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'user_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnAvatar TEXT
      )
    ''');
  }

  // Insert user data
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(tableName, user);
  }

  // Retrieve all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query(tableName);
  }
}
