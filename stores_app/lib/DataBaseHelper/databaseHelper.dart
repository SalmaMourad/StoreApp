import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stores_app/Stores/store.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<void> _openDatabase() async {
    if (_db != null) {
      return;
    }
    try {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'stores.db');
      _db = await openDatabase(path, version: 3,
          onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE stores(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            latitude REAL,
            longitude REAL
          )
        ''');
        await _createUserFavoritesTable(db);
      }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 3) {
          await _createUserFavoritesTable(db);
        }
      });
    } catch (e) {
      print('Error opening database: ${e.toString()}');
      rethrow;
    }
  }


Future<Map<String, double>> getFavoriteStoreLocation(int storeId) async {
    try {
      await _openDatabase();
      List<Map<String, dynamic>> storeData = await _db!.query(
        'stores',
        where: 'id = ?',
        whereArgs: [storeId],
      );

      if (storeData.isNotEmpty) {
        double latitude = storeData.first['latitude'];
        double longitude = storeData.first['longitude'];
        return {'latitude': latitude, 'longitude': longitude};
      } else {
        throw Exception('Store not found');
      }
    } catch (e) {
      print('Error retrieving favorite store location: $e');
      rethrow;
    }
  }


  Future<void> _createUserFavoritesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS UserFavorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        storeId INTEGER,
        FOREIGN KEY (userId) REFERENCES users(id),
        FOREIGN KEY (storeId) REFERENCES stores(id)
      )
    ''');
  }

  Future<int> insertStore(Store store) async {
    try {
      await _openDatabase();
      List<Map<String, dynamic>> existingStores = await _db!.query(
        'stores',
        where: 'name = ? AND latitude = ? AND longitude = ?',
        whereArgs: [store.name, store.latitude, store.longitude],
      );

      if (existingStores.isNotEmpty) {
        return -1;
      }

      return await _db!.insert('stores', store.toMap());
    } catch (e) {
      print('Error inserting store: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> insertDummyData() async {
    try {
      await _openDatabase();
      List<Store> dummyStores = [
        Store(
          name: 'Store 1',
          latitude: 30.99,
          longitude: 40.99,
        ),
        Store(
          name: 'Store 2',
          latitude: 30.99,
          longitude: 40.99,
        ),
        Store(
          name: 'Store 3',
          latitude: 30.99,
          longitude: 40.99,
        ),
        Store(
          name: 'Store 4',
          latitude: 55.99,
          longitude: 65.99,
        ),
        Store(
          name: 'Store 5',
          latitude: 65.99,
          longitude: 70.99,
        ),
      ];

      for (Store store in dummyStores) {
        await insertStore(store);
      }
    } catch (e) {
      print('Error inserting dummy data: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getStores() async {
    try {
      await _openDatabase();
      return await _db!.query('stores');
    } catch (e) {
      print('Error retrieving stores: ${e.toString()}');
      rethrow;
    }
  }

  Future<int> updateStore(Store store) async {
    try {
      await _openDatabase();
      return await _db!.update('stores', store.toMap(),
          where: 'id = ?', whereArgs: [store.id]);
    } catch (e) {
      print('Error updating store: ${e.toString()}');
      rethrow;
    }
  }

  Future<int> deleteStore(int id) async {
    try {
      await _openDatabase();
      return await _db!.delete('stores', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting store: ${e.toString()}');
      rethrow;
    }
  }

  Future<int> insertUserFavorite(int userId, int storeId) async {
    try {
      await _openDatabase();
      return await _db!.insert('UserFavorites', {
        'userId': userId,
        'storeId': storeId,
      });
    } catch (e) {
      print('Error inserting user favorite: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUserFavorites(int userId) async {
    try {
      await _openDatabase();
      return await _db!
          .query('UserFavorites', where: 'userId = ?', whereArgs: [userId]);
    } catch (e) {
      print('Error retrieving user favorites: ${e.toString()}');
      rethrow;
    }
  }

  Future<int> deleteUserFavorite(int userId, int storeId) async {
    try {
      await _openDatabase();
      return await _db!.delete('UserFavorites',
          where: 'userId = ? AND storeId = ?', whereArgs: [userId, storeId]);
    } catch (e) {
      print('Error deleting user favorite: ${e.toString()}');
      rethrow;
    }
  }

  Future<bool> isFavorite(int userId, int storeId) async {
    try {
      await _openDatabase();
      List<Map<String, dynamic>> favorites = await _db!.query(
        'UserFavorites',
        where: 'userId = ? AND storeId = ?',
        whereArgs: [userId, storeId],
      );
      return favorites.isNotEmpty;
    } catch (e) {
      print('Error checking if store is favorite: $e');
      return false;
    }
  }

  Future<List<Store>> getUserFavoriteStores(int userId) async {
    try {
      await _openDatabase();
      List<Map<String, dynamic>> favoriteStoreMaps = await _db!.rawQuery('''
        SELECT stores.* FROM stores
        INNER JOIN UserFavorites ON stores.id = UserFavorites.storeId
        WHERE UserFavorites.userId = ?
      ''', [userId]);

      List<Store> favoriteStores = [];
      for (var favoriteStoreMap in favoriteStoreMaps) {
        favoriteStores.add(Store.fromMap(favoriteStoreMap));
      }
      return favoriteStores;
    } catch (e) {
      print('Error retrieving user favorite stores: ${e.toString()}');
      throw e;
    }
  }
}


// Future<Map<String, dynamic>?> getFavoriteStoreLocation(int userId) async {
//     try {
//       await _openDatabase();
//       List<Map<String, dynamic>> favoriteStoreMaps = await _db!.rawQuery('''
//         SELECT stores.latitude, stores.longitude FROM stores
//         INNER JOIN UserFavorites ON stores.id = UserFavorites.storeId
//         WHERE UserFavorites.userId = ?
//       ''', [userId]);

//       if (favoriteStoreMaps.isNotEmpty) {
//         // If there are favorite stores, return the location of the first one.
//         return favoriteStoreMaps[0];
//       } else {
//         // If there are no favorite stores for the user, return null.
//         return null;
//       }
//     } catch (e) {
//       print('Error retrieving favorite store location: ${e.toString()}');
//       rethrow;
//     }
//   }