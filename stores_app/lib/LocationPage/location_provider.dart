import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stores_app/DataBaseHelper/databaseHelper.dart';
import 'package:stores_app/Stores/store.dart';

class LocationProvider extends ChangeNotifier {
  int _userId = 0;
  Position? _currentPosition;
  Map<String, double>? _selectedStoreLocation;
  double _distanceToStore = 0.0;
  List<Store> _favoriteStores = [];

  int get userId => _userId;
  Position? get currentPosition => _currentPosition;
  Map<String, double>? get selectedStoreLocation => _selectedStoreLocation;
  double get distanceToStore => _distanceToStore;
  List<Store> get favoriteStores => _favoriteStores;

  LocationProvider() {
    print('Initializing LocationProvider...');
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      print('Initializing FavoriteListProvider...');
      await loadUserId(); // Wait for loadUserId to finish
      notifyListeners();
      print('FavoriteListProvider initialization complete');
    } catch (e) {
      print('Error initializing favorite list: $e');
    }
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId =
        prefs.getInt('userId') ?? 0; // Default value if userId is not found
    await getFavoriteStores(); // Wait for getFavoriteStores to finish
  }

  Future<void> getFavoriteStores() async {
    print('Fetching favorite stores...');
    try {
      List<Store> userFavoriteStores =
          await DatabaseHelper().getUserFavoriteStores(_userId);
      _favoriteStores = userFavoriteStores;

      notifyListeners();
    } catch (e) {
      print('Error fetching favorite stores: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    Position position = await geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentPosition = position;
    notifyListeners();
  }

  Future<void> getFavoriteStoreLocation(Store store) async {
    try {
      _selectedStoreLocation =
          await DatabaseHelper().getFavoriteStoreLocation(store.id!);
      print('Store Location: $_selectedStoreLocation');
      notifyListeners();
    } catch (e) {
      print('Error fetching favorite store location: $e');
    }
  }

  void calculateDistance() {
    if (_currentPosition != null && _selectedStoreLocation != null) {
      double distance = _calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _selectedStoreLocation!['latitude']!,
        _selectedStoreLocation!['longitude']!,
      );
      _distanceToStore = distance;
      notifyListeners();
    }
  }

    // Haversine formula
  double _calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    const double earthRadius = 6371.0; // Earth radius in kilometers

    // Convert latitude and longitude from degrees to radians
    double lat1 = startLat * 3.141592653589793 / 180.0;
    double lon1 = startLng * 3.141592653589793 / 180.0;
    double lat2 = endLat * 3.141592653589793 / 180.0;
    double lon2 = endLng * 3.141592653589793 / 180.0;

    // Calculate differences between latitude and longitude
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    // Haversine formula
    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance; // Distance in kilometers
  }

  Future<void> fetchFavoriteStores() async {
    await getFavoriteStores();
  }
}
