import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stores_app/DataBaseHelper/databaseHelper.dart';
import 'package:stores_app/Stores/store.dart';
import 'dart:math' as math;

class FavoriteListPage extends StatefulWidget {
  static const String id = "FavoriteListPage";

  @override
  _FavoriteListPageState createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  late int userId;
  late List<Store> favoriteStores = [];
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchUserId().then((_) {
      _fetchFavoriteStores();
    });
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
  }

  Future<void> _fetchFavoriteStores() async {
    try {
      List<Store> userFavoriteStores =
          await DatabaseHelper().getUserFavoriteStores(userId);
      setState(() {
        favoriteStores = userFavoriteStores;
      });
    } catch (e) {
      print('Error fetching favorite stores: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Stores'),
        backgroundColor: const Color(0xFF9A4253),
      ),
      body: favoriteStores.isEmpty
          ? Center(
              child: Text('No favorite stores yet.'),
            )
          : ListView.builder(
              itemCount: favoriteStores.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(favoriteStores[index].name),
                            subtitle: Text(
                                'Latitude: ${favoriteStores[index].latitude}, Longitude: ${favoriteStores[index].longitude}'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _getCurrentLocationAndCalculateDistance(
                                  favoriteStores[index]);
                            },
                            child: Text('Calculate Distance'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _getCurrentLocationAndCalculateDistance(Store store) async {
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });

    if (_currentPosition != null) {
      double distanceInMeters = calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          store.latitude,
          store.longitude);
      // You can display the distance wherever you want, for example, in a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Distance'),
            content: Text(
                'Distance to ${store.name}: ${distanceInMeters.toStringAsFixed(2)} meters'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  double calculateDistance(
      double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    const int earthRadius = 6371000; // meters
    double lat1 = _radians(startLatitude);
    double lon1 = _radians(startLongitude);
    double lat2 = _radians(endLatitude);
    double lon2 = _radians(endLongitude);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    double distance = earthRadius * c;

    return distance;
  }

  double _radians(double degrees) {
    return degrees * (math.pi / 180);
  }
}
