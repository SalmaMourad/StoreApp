import 'package:flutter/material.dart';
import 'package:stores_app/DataBaseHelper/databaseHelper.dart';
import 'package:stores_app/Stores/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoresProvider extends ChangeNotifier {
  late DatabaseHelper _databaseHelper;
  List<Store> _stores = [];
  int _userId = 0;

  int get userId => _userId;

  StoresProvider() {
    _databaseHelper = DatabaseHelper();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getUserID();
    await _databaseHelper.insertDummyData();
    await _getStoresFromDatabase();
  }

  Future<void> _getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId') ?? 0;
    print('User ID retrieved: $_userId');
  }

  Future<void> _getStoresFromDatabase() async {
    try {
      List<Map<String, dynamic>> storeMaps = await _databaseHelper.getStores();
      List<Store> retrievedStores = [];
      for (var storeMap in storeMaps) {
        var store = Store.fromMap(storeMap);
        // Check if store is a favorite for the current user
        store.isFavorite =
            await _databaseHelper.isFavorite(_userId, store.id ?? 0);
        retrievedStores.add(store);
      }
      _stores = retrievedStores;
      notifyListeners();
      print('Stores retrieved: $_stores');
    } catch (e) {
      print('Error retrieving stores: $e');
    }
  }

  List<Store> get stores => _stores;

  Future<void> addFavorite(Store store) async {
    try {
      // Add logic to add store to favorites in the database
      await _databaseHelper.insertUserFavorite(_userId, store.id!);
      // Update local store list
      store.isFavorite = true;
      notifyListeners(); // Notify listeners after updating local data
      print('Store ${store.name} added to favorites!');
    } catch (e) {
      print('Error adding store to favorites: $e');
    }
  }

  Future<void> removeFavorite(Store store) async {
    try {
      // Add logic to remove store from favorites in the database
      await _databaseHelper.deleteUserFavorite(_userId, store.id!);
      // Update local store list
      store.isFavorite = false;
      notifyListeners(); // Notify listeners after updating local data
      print('Store ${store.name} removed from favorites!');
    } catch (e) {
      print('Error removing store from favorites: $e');
    }
  }
}
