import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        
        password TEXT,
       
        imagePath TEXT 
      )
    ''');
  }

  // void _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < 2) {
  //     // Perform the necessary upgrade operations here
  //     await db.execute('ALTER TABLE users ADD COLUMN imagePath TEXT');
  //   }
  // }

  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      // Check if the email already exists
      Map<String, dynamic>? existingUser = await getUserByEmail(user['email']);
      if (existingUser != null) {
        // Email already exists, return an error code or throw an exception
        return -2; // You can use any negative value to represent this error
      }

      Database db = await database;
      int userId = await db.insert('users', user);
      return userId; // Return the inserted user ID
    } catch (e) {
      print('Error inserting user: $e');
      return -1; // Return an error code or throw an exception as per your application logic
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (users.isNotEmpty) {
      return users.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmailAndPassword(
      String email, String password) async {
    final Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (users.isNotEmpty) {
      return users.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (users.isNotEmpty) {
      return users.first;
    } else {
      return null;
    }
  }
  // In the DatabaseHelper class

// In the DatabaseHelper class

  Future<void> updateUserInDatabase(
      int userId, Map<String, dynamic> userData) async {
    try {
      Database db = await database;
      // Update user data in the database based on user ID
      await db.update(
        'users',
        userData,
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('Error updating user: $e');
      // Handle error as per your application logic
    }
  }
}
