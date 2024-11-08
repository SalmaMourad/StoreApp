import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stores_app/DataBaseHelper/databaseHelper.dart';
import 'package:stores_app/Stores/store.dart';

class FavoriteListProvider extends ChangeNotifier {
  late int _userId;
  late List<Store> _favoriteStores = [];

  int get userId => _userId;
  List<Store> get favoriteStores => _favoriteStores;

  FavoriteListProvider() {
    print('Initializing FavoriteListProvider...');
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      print('Initializing FavoriteListProvider...');
      await _fetchUserId();
      await _fetchFavoriteStores();
      notifyListeners();
      print('FavoriteListProvider initialization complete');
    } catch (e) {
      print('Error initializing favorite list: $e');
    }
  }

  Future<void> _fetchUserId() async {
    print('Fetching user ID...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId') ?? 0;
    print('User ID retrieved: $_userId');
  }

  Future<void> _fetchFavoriteStores() async {
    print('Fetching favorite stores...');
    try {
      List<Store> userFavoriteStores =
          await DatabaseHelper().getUserFavoriteStores(_userId);
      _favoriteStores = userFavoriteStores;
      notifyListeners();
      print('Favorite stores retrieved: $_favoriteStores');
    } catch (e) {
      print('Error fetching favorite stores: $e');
    }
  }

  // New method to fetch favorite stores
  Future<void> fetchFavoriteStores() async {
    await _fetchFavoriteStores();
  }
}
