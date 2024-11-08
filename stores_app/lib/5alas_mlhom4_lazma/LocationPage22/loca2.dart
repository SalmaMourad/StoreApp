// old before ProviderState managment 


// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stores_app/databaseHelper.dart';
// import 'package:stores_app/store.dart';

// class LocationPage extends StatefulWidget {
//   @override
//   static String id = "location";

//   _LocationPageState createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   late int userId;
//   Position? _currentPosition;
//   Map<String, double>? _selectedStoreLocation;
//   double _distanceToStore = 0.0;

//   List<Store> _favoriteStores = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//   }

//   void _loadUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId =
//           prefs.getInt('userId') ?? 0; // Default value if userId is not found
//     });
//     _getFavoriteStores();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Finding the Location'),
//         backgroundColor: const Color(0xFF9A4253),
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             SizedBox(height: 25),
//             ElevatedButton(
//               onPressed: () {
//                 _getCurrentLocation();
//               },
//               child: Text('Get Current Location'),
//               style: ElevatedButton.styleFrom(
//                 fixedSize: const Size(360, 48),
//                 backgroundColor: const Color(0xFF9A4253),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: 15),
//             _currentPosition != null
//                 ? Text(
//                     'Current Location: Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}')
//                 : Text('Location not fetched yet'),
//             SizedBox(height: 15),
//             ElevatedButton(
//               onPressed: () {
//                 _showStoreList(context);
//               },
//               child: Text('Choose Favorite Store'),
//               style: ElevatedButton.styleFrom(
//                 fixedSize: const Size(360, 48),
//                 backgroundColor: const Color(0xFF9A4253),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: 15),
//             _selectedStoreLocation != null
//                 ? Text(
//                     'Selected Store Location: Latitude: ${_selectedStoreLocation!['latitude']}, Longitude: ${_selectedStoreLocation!['longitude']}')
//                 : Text('No store selected'),
//             SizedBox(height: 15),
//             ElevatedButton(
//               onPressed: () {
//                 if (_currentPosition != null &&
//                     _selectedStoreLocation != null) {
//                   _calculateDistance();
//                 }
//               },
//               child: Text('Calculate Distance'),
//               style: ElevatedButton.styleFrom(
//                 fixedSize: const Size(360, 48),
//                 backgroundColor: const Color(0xFF9A4253),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: 15),
//             _distanceToStore != 0.0
//                 ? Text('Distance to store: $_distanceToStore km')
//                 : SizedBox(),
//             SizedBox(height: 15),
//           ],
//         ),
//       ),
//     );
//   }

//   void _getCurrentLocation() async {
//     final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
//     Position position = await geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       _currentPosition = position;
//     });
//   }

//   void _getFavoriteStores() async {
//     try {
//       List<Store> favoriteStores =
//           await DatabaseHelper().getUserFavoriteStores(userId);
//       setState(() {
//         _favoriteStores = favoriteStores;
//       });
//     } catch (e) {
//       print('Error fetching favorite stores: $e');
//     }
//   }

//   void _showStoreList(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return DraggableScrollableSheet(
//           builder: (context, scrollController) {
//             return ListView.builder(
//               controller: scrollController,
//               itemCount: _favoriteStores.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_favoriteStores[index].name),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _getFavoriteStoreLocation(_favoriteStores[index]);
//                   },
//                 );
//               },
//             );
//           },
//           initialChildSize: 0.5,
//           minChildSize: 0.25,
//           maxChildSize: 0.8,
//         );
//       },
//     );
//   }

//   void _getFavoriteStoreLocation(Store store) async {
//     try {
//       Map<String, double> storeLocation =
//           await DatabaseHelper().getFavoriteStoreLocation(store.id!);
//       print('Store Location: $storeLocation');

//       setState(() {
//         _selectedStoreLocation = storeLocation;
//       });
//     } catch (e) {
//       print('Error fetching favorite store location: $e');
//     }
//   }

//   void _calculateDistance() {
//     double distance = calculateDistance(
//       _currentPosition!.latitude,
//       _currentPosition!.longitude,
//       _selectedStoreLocation!['latitude']!,
//       _selectedStoreLocation!['longitude']!,
//     );

//     setState(() {
//       _distanceToStore = distance;
//     });
//   }

//   // Calculate distance using Haversine formula
//   double calculateDistance(
//       double startLat, double startLng, double endLat, double endLng) {
//     const double earthRadius = 6371.0; // Earth radius in kilometers

//     // Convert latitude and longitude from degrees to radians
//     double lat1 = startLat * 3.141592653589793 / 180.0;
//     double lon1 = startLng * 3.141592653589793 / 180.0;
//     double lat2 = endLat * 3.141592653589793 / 180.0;
//     double lon2 = endLng * 3.141592653589793 / 180.0;

//     // Calculate differences between latitude and longitude
//     double dLat = lat2 - lat1;
//     double dLon = lon2 - lon1;

//     // Haversine formula
//     double a =
//         pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     double distance = earthRadius * c;

//     return distance; // Distance in kilometers
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: LocationPage(),
//   ));
// }


// // import 'dart:math';

// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:stores_app/databaseHelper.dart';
// // import 'package:stores_app/store.dart';

// // class LocationPage extends StatefulWidget {
// //   @override
// //   static String id = "location";

// //   _LocationPageState createState() => _LocationPageState();
// // }

// // class _LocationPageState extends State<LocationPage> {
// //   late int userId;
// //   Position? _currentPosition;
// //   Map<String, double>? _selectedStoreLocation;
// //   double _distanceToStore = 0.0; // Initialize _distanceToStore

// //   List<Store> _favoriteStores = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadUserId();
// //   }

// //   void _loadUserId() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       userId = prefs.getInt('userId') ?? 0; // Default value if userId is not found
// //     });
// //     _getFavoriteStores();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Finding the Location'),
// //         backgroundColor: const Color(0xFF9A4253),
// //       ),
// //       body: Center(
// //         child: Column(
// //           children: <Widget>[
// //             SizedBox(height: 25),
// //             ElevatedButton(
// //               onPressed: () {
// //                 _getCurrentLocation();
// //               },
// //               child: Text('Get Current Location'),
// //               style: ElevatedButton.styleFrom(
// //                 fixedSize: const Size(360, 48),
// //                 backgroundColor: const Color(0xFF9A4253),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(18.0),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 15),
// //             _currentPosition != null
// //                 ? Text(
// //                     'Current Location: Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}')
// //                 : Text('Location not fetched yet'),
// //             SizedBox(height: 15),
// //             _selectedStoreLocation != null
// //                 ? Text(
// //                     'Selected Store Location: Latitude: ${_selectedStoreLocation!['latitude']}, Longitude: ${_selectedStoreLocation!['longitude']}')
// //                 : Text('No store selected'),
// //             SizedBox(height: 15),
// //             _distanceToStore != 0.0
// //                 ? Text('Distance to store: $_distanceToStore km')
// //                 : SizedBox(),
// //             SizedBox(height: 15),
// //             ElevatedButton(
// //               onPressed: () {
// //                 _showStoreList(context);
// //               },
// //               child: Text('Choose Favorite Store'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _getCurrentLocation() async {
// //     final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
// //     Position position = await geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);

// //     setState(() {
// //       _currentPosition = position;
// //     });
// //   }

// //   void _getFavoriteStores() async {
// //     try {
// //       List<Store> favoriteStores =
// //           await DatabaseHelper().getUserFavoriteStores(userId);
// //       setState(() {
// //         _favoriteStores = favoriteStores;
// //       });
// //     } catch (e) {
// //       print('Error fetching favorite stores: $e');
// //     }
// //   }

// //   void _showStoreList(BuildContext context) {
// //     showModalBottomSheet(
// //       context: context,
// //       builder: (context) {
// //         return DraggableScrollableSheet(
// //           builder: (context, scrollController) {
// //             return ListView.builder(
// //               controller: scrollController,
// //               itemCount: _favoriteStores.length,
// //               itemBuilder: (context, index) {
// //                 return ListTile(
// //                   title: Text(_favoriteStores[index].name),
// //                   onTap: () {
// //                     Navigator.pop(context);
// //                     _getFavoriteStoreLocation(_favoriteStores[index]);
// //                   },
// //                 );
// //               },
// //             );
// //           },
// //           initialChildSize: 0.5,
// //           minChildSize: 0.25,
// //           maxChildSize: 0.8,
// //         );
// //       },
// //     );
// //   }

// //   void _getFavoriteStoreLocation(Store store) async {
// //     try {
// //       Map<String, double> storeLocation =
// //           await DatabaseHelper().getFavoriteStoreLocation(store.id!);
// //       print('Store Location: $storeLocation');

// //       // Calculate distance between current location and store location
// //       double distance = calculateDistance(
// //         _currentPosition!.latitude,
// //         _currentPosition!.longitude,
// //         storeLocation['latitude']!,
// //         storeLocation['longitude']!,
// //       );

// //       print('Distance to store: $distance km');

// //       setState(() {
// //         _selectedStoreLocation = storeLocation;
// //         _distanceToStore = distance; // Update _distanceToStore
// //       });
// //     } catch (e) {
// //       print('Error fetching favorite store location: $e');
// //     }
// //   }

// //   // Calculate distance using Haversine formula
// //   double calculateDistance(
// //       double startLat, double startLng, double endLat, double endLng) {
// //     const double earthRadius = 6371.0; // Earth radius in kilometers

// //     // Convert latitude and longitude from degrees to radians
// //     double lat1 = startLat * 3.141592653589793 / 180.0;
// //     double lon1 = startLng * 3.141592653589793 / 180.0;
// //     double lat2 = endLat * 3.141592653589793 / 180.0;
// //     double lon2 = endLng * 3.141592653589793 / 180.0;

// //     // Calculate differences between latitude and longitude
// //     double dLat = lat2 - lat1;
// //     double dLon = lon2 - lon1;

// //     // Haversine formula
// //     double a = pow(sin(dLat / 2), 2) +
// //         cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
// //     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
// //     double distance = earthRadius * c;

// //     return distance; // Distance in kilometers
// //   }
// // }

// // void main() {
// //   runApp(MaterialApp(
// //     home: LocationPage(),
// //   ));
// // }


// // // import 'package:flutter/material.dart';
// // // import 'package:geolocator/geolocator.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:stores_app/databaseHelper.dart';
// // // import 'package:stores_app/store.dart';
// // //   import 'dart:math';


// // // class LocationPage extends StatefulWidget {
// // //   @override
// // //   static String id = "location";

// // //   _LocationPageState createState() => _LocationPageState();
// // // }

// // // class _LocationPageState extends State<LocationPage> {
// // //   late int userId;
// // //   Position? _currentPosition;
// // //   Map<String, double>? _selectedStoreLocation; // Store the selected store's location

// // //   List<Store> _favoriteStores = [];

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadUserId();
// // //   }

// // //   void _loadUserId() async {
// // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // //     setState(() {
// // //       userId = prefs.getInt('userId') ?? 0; // Default value if userId is not found
// // //     });
// // //     _getFavoriteStores();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Finding the Location'),
// // //         backgroundColor: const Color(0xFF9A4253),
// // //       ),
// // //       body: Center(
// // //         child: Column(
// // //           children: <Widget>[
// // //             SizedBox(height: 25),
// // //             ElevatedButton(
// // //               onPressed: () {
// // //                 _getCurrentLocation();
// // //               },
// // //               child: Text('Get Current Location'),
// // //               style: ElevatedButton.styleFrom(
// // //                 fixedSize: const Size(360, 48),
// // //                 backgroundColor: const Color(0xFF9A4253),
// // //                 shape: RoundedRectangleBorder(
// // //                   borderRadius: BorderRadius.circular(18.0),
// // //                 ),
// // //               ),
// // //             ),
// // //             SizedBox(height: 15),
// // //             _currentPosition != null
// // //                 ? Text(
// // //                     'Current Location: Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}')
// // //                 : Text('Location not fetched yet'),
// // //             SizedBox(height: 15),
// // //             _selectedStoreLocation != null
// // //                 ? Text(
// // //                     'Selected Store Location: Latitude: ${_selectedStoreLocation!['latitude']}, Longitude: ${_selectedStoreLocation!['longitude']}')
// // //                 : Text('No store selected'),
// // //             SizedBox(height: 15),
// // //             ElevatedButton(
// // //               onPressed: () {
// // //                 _showStoreList(context);
// // //               },
// // //               child: Text('Choose Favorite Store'),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _getCurrentLocation() async {
// // //     final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
// // //     Position position = await geolocator.getCurrentPosition(
// // //         desiredAccuracy: LocationAccuracy.high);

// // //     setState(() {
// // //       _currentPosition = position;
// // //     });
// // //   }

// // //   void _getFavoriteStores() async {
// // //     try {
// // //       List<Store> favoriteStores =
// // //           await DatabaseHelper().getUserFavoriteStores(userId);
// // //       setState(() {
// // //         _favoriteStores = favoriteStores;
// // //       });
// // //     } catch (e) {
// // //       print('Error fetching favorite stores: $e');
// // //     }
// // //   }

// // //   void _showStoreList(BuildContext context) {
// // //     showModalBottomSheet(
// // //       context: context,
// // //       builder: (context) {
// // //         return DraggableScrollableSheet(
// // //           builder: (context, scrollController) {
// // //             return ListView.builder(
// // //               controller: scrollController,
// // //               itemCount: _favoriteStores.length,
// // //               itemBuilder: (context, index) {
// // //                 return ListTile(
// // //                   title: Text(_favoriteStores[index].name),
// // //                   onTap: () {
// // //                     Navigator.pop(context);
// // //                     _getFavoriteStoreLocation(_favoriteStores[index]);
// // //                   },
// // //                 );
// // //               },
// // //             );
// // //           },
// // //           initialChildSize: 0.5,
// // //           minChildSize: 0.25,
// // //           maxChildSize: 0.8,
// // //         );
// // //       },
// // //     );
// // //   }

// // // //   void _getFavoriteStoreLocation(Store store) async {
// // // //     try {
// // // //       Map<String, double> storeLocation =
// // // // await DatabaseHelper().getFavoriteStoreLocation(store.id!);
// // // //       print('Store Location: $storeLocation');
// // // //       setState(() {
// // // //         _selectedStoreLocation = storeLocation; // Update the selected store location
// // // //       });
// // // //     } catch (e) {
// // // //       print('Error fetching favorite store location: $e');
// // // //     }
// // // //   }
// // // void _getFavoriteStoreLocation(Store store) async {
// // //   try {
// // //     Map<String, double> storeLocation =
// // //         await DatabaseHelper().getFavoriteStoreLocation(store.id!);
// // //     print('Store Location: $storeLocation');

// // //     // Calculate distance between current location and store location
// // //     double distance = calculateDistance(
// // //       _currentPosition!.latitude,
// // //       _currentPosition!.longitude,
// // //       storeLocation['latitude']!,
// // //       storeLocation['longitude']!,
// // //     );

// // //     print('Distance to store: $distance km');

// // //     setState(() {
// // //       _selectedStoreLocation = storeLocation;
// // //       _distanceToStore = distance;
// // //     });
// // //   } catch (e) {
// // //     print('Error fetching favorite store location: $e');
// // //   }
// // // }


// // // // Calculate distance using Haversine formula
// // // double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
// // //   const double earthRadius = 6371.0; // Earth radius in kilometers

// // //   // Convert latitude and longitude from degrees to radians
// // //   double lat1 = startLat * pi / 180.0;
// // //   double lon1 = startLng * pi / 180.0;
// // //   double lat2 = endLat * pi / 180.0;
// // //   double lon2 = endLng * pi / 180.0;

// // //   // Calculate differences between latitude and longitude
// // //   double dLat = lat2 - lat1;
// // //   double dLon = lon2 - lon1;

// // //   // Haversine formula
// // //   double a = pow(sin(dLat / 2), 2) +
// // //       cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
// // //   double c = 2 * atan2(sqrt(a), sqrt(1 - a));
// // //   double distance = earthRadius * c;

// // //   return distance; // Distance in kilometers
// // // }

// // // }

// // // void main() {
// // //   runApp(MaterialApp(
// // //     home: LocationPage(),
// // //   ));
// // // }

// // // // import 'package:flutter/material.dart';
// // // // import 'package:geolocator/geolocator.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:stores_app/databaseHelper.dart';
// // // // import 'package:stores_app/store.dart';

// // // // class LocationPage extends StatefulWidget {
// // // //   @override
// // // //   static String id = "location";

// // // //   _LocationPageState createState() => _LocationPageState();
// // // // }

// // // // class _LocationPageState extends State<LocationPage> {
// // // //    late int userId;
// // // //   Position? _currentPosition;
// // // //   List<Store> _favoriteStores = [];

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _loadUserId();
// // // //   }

// // // //   void _loadUserId() async {
// // // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // // //     setState(() {
// // // //       userId = prefs.getInt('userId') ?? 0; // Default value if userId is not found
// // // //     });
// // // //     _getFavoriteStores();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('Finding the Location'),
// // // //         backgroundColor: const Color(0xFF9A4253),
// // // //       ),
// // // //       body: Center(
// // // //         child: Column(
// // // //           children: <Widget>[
// // // //             SizedBox(height: 25),
// // // //             ElevatedButton(
// // // //               onPressed: () {
// // // //                 _getCurrentLocation();
// // // //               },
// // // //               child: Text('Get Current Location'),
// // // //               style: ElevatedButton.styleFrom(
// // // //                 fixedSize: const Size(360, 48),
// // // //                 backgroundColor: const Color(0xFF9A4253),
// // // //                 shape: RoundedRectangleBorder(
// // // //                   borderRadius: BorderRadius.circular(18.0),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             SizedBox(height: 15),
// // // //             _currentPosition != null
// // // //                 ? Text(
// // // //                     'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}')
// // // //                 : Text('Location not fetched yet'),
// // // //             SizedBox(height: 15),
// // // //             ElevatedButton(
// // // //               onPressed: () {
// // // //                 _showStoreList(context);
// // // //               },
// // // //               child: Text('Choose Favorite Store'),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _getCurrentLocation() async {
// // // //     final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
// // // //     Position position = await geolocator.getCurrentPosition(
// // // //         desiredAccuracy: LocationAccuracy.high);

// // // //     setState(() {
// // // //       _currentPosition = position;
// // // //     });
// // // //   }

// // // //   void _getFavoriteStores() async {
// // // //     try {
// // // //       List<Store> favoriteStores =
// // // //           await DatabaseHelper().getUserFavoriteStores(userId);
// // // //       setState(() {
// // // //         _favoriteStores = favoriteStores;
// // // //       });
// // // //     } catch (e) {
// // // //       print('Error fetching favorite stores: $e');
// // // //     }
// // // //   }

// // // //   void _showStoreList(BuildContext context) {
// // // //     showModalBottomSheet(
// // // //       context: context,
// // // //       builder: (context) {
// // // //         return DraggableScrollableSheet(
// // // //           builder: (context, scrollController) {
// // // //             return ListView.builder(
// // // //               controller: scrollController,
// // // //               itemCount: _favoriteStores.length,
// // // //               itemBuilder: (context, index) {
// // // //                 return ListTile(
// // // //                   title: Text(_favoriteStores[index].name),
// // // //                   onTap: () {
// // // //                     Navigator.pop(context);
// // // //                     _getFavoriteStoreLocation(_favoriteStores[index].id);
// // // //                   },
// // // //                 );
// // // //               },
// // // //             );
// // // //           },
// // // //           initialChildSize: 0.5,
// // // //           minChildSize: 0.25,
// // // //           maxChildSize: 0.8,
// // // //         );
// // // //       },
// // // //     );
// // // //   }

// // // //   void _getFavoriteStoreLocation(int? storeId) async {
// // // //     if (storeId != null) {
// // // //       try {
// // // //         Map<String, double> storeLocation =
// // // //             await DatabaseHelper().getFavoriteStoreLocation(storeId);
// // // //         print('Store Location: $storeLocation');
// // // //               _showLocationDialog(storeLocation);

// // // //         // Do something with the store location, such as calculating distance
// // // //       } catch (e) {
// // // //         print('Error fetching favorite store location: $e');
// // // //       }
// // // //     } else {
// // // //       print('Invalid store ID');
// // // //     }
// // // //   }

// // // //    void _showLocationDialog(Map<String, double> storeLocation) {
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (BuildContext context) {
// // // //         return AlertDialog(
// // // //           title: Text('Store Location'),
// // // //           content: Text(
// // // //               'Latitude: ${storeLocation['latitude']}, Longitude: ${storeLocation['longitude']}'),
// // // //           actions: <Widget>[
// // // //             TextButton(
// // // //               onPressed: () {
// // // //                 Navigator.of(context).pop();
// // // //               },
// // // //               child: Text('Close'),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );
// // // //   }

// // // // }

// // // // void main() {
// // // //   runApp(MaterialApp(
// // // //     home: LocationPage(),
// // // //   ));
// // // // }

// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:geolocator/geolocator.dart';
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import 'package:stores_app/databaseHelper.dart';
// // // // // import 'package:stores_app/store.dart';

// // // // // class LocationPage extends StatefulWidget {
// // // // //   @override
// // // // //       static String id = "location";

// // // // //   _LocationPageState createState() => _LocationPageState();
// // // // // }

// // // // // class _LocationPageState extends State<LocationPage> {
// // // // //     late int userId;
// // // // // // int? _selectedStoreId;
// // // // // int? _selectedStoreId;


// // // // //   Position? _currentPosition;
// // // // //   List<Store> _favoriteStores = [];

// // // // //   @override
// // // // // void initState() {
// // // // //   super.initState();
// // // // //   _loadUserId(); // Load user ID from shared preferences
// // // // // }

// // // // // void _loadUserId() async {
// // // // //   SharedPreferences prefs = await SharedPreferences.getInstance();
// // // // //   setState(() {
// // // // //     userId = prefs.getInt('userId') ?? 0; // Default value if userId is not found
// // // // //   });
// // // // //   _getFavoriteStores();
// // // // // }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         title: Text('Finding the Location'),
// // // // //         backgroundColor: const Color(0xFF9A4253),
// // // // //       ),
// // // // //       body: Center(
// // // // //         child: Column(
// // // // //           children: <Widget>[
// // // // //             SizedBox(height: 25),
// // // // //             ElevatedButton(
// // // // //               onPressed: () {
// // // // //                 _getCurrentLocation();
// // // // //               },
// // // // //               child: Text('Get Current Location'),
// // // // //               style: ElevatedButton.styleFrom(
// // // // //                 fixedSize: const Size(360, 48),
// // // // //                 backgroundColor: const Color(0xFF9A4253),
// // // // //                 shape: RoundedRectangleBorder(
// // // // //                   borderRadius: BorderRadius.circular(18.0),
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //             SizedBox(height: 15),
// // // // //             _currentPosition != null
// // // // //                 ? Text(
// // // // //                     'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}')
// // // // //                 : Text('Location not fetched yet'),
// // // // //             SizedBox(height: 15),
// // // // //             Text(
// // // // //               'Favorite Stores:',
// // // // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // // //             ),
// // // // //             // Expanded(
// // // // //             //   child: ListView.builder(
// // // // //             //     itemCount: _favoriteStores.length,
// // // // //             //     itemBuilder: (context, index) {
// // // // //             //       return ListTile(
// // // // //             //         title: Text(_favoriteStores[index].name),
// // // // //             //         onTap: () {
// // // // //             //           _getFavoriteStoreLocation(_favoriteStores[index].id);
// // // // //             //         },
// // // // //             //       );
// // // // //             //     },
// // // // //             //   ),
// // // // //             // ),
          
// // // // // Expanded(
// // // // //   child: ListView(
// // // // //     children: _favoriteStores.map((store) {
// // // // //       return RadioListTile<int?>(
// // // // //         title: Text(store.name),
// // // // //         value: store.id,
// // // // //         groupValue: _selectedStoreId,
// // // // //         onChanged: (int? value) {
// // // // //           setState(() {
// // // // //             _selectedStoreId = value;
// // // // //           });
// // // // //           _getFavoriteStoreLocation(value);
// // // // //         },
// // // // //       );
// // // // //     }).toList(),
// // // // //   ),
// // // // // ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   void _getCurrentLocation() async {
// // // // //     final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
// // // // //     Position position = await geolocator.getCurrentPosition(
// // // // //         desiredAccuracy: LocationAccuracy.high);

// // // // //     setState(() {
// // // // //       _currentPosition = position;
// // // // //     });
// // // // //   }


// // // // // void _getFavoriteStores() async {
// // // // //   try {
// // // // //     // Replace 'currentUserId' with the actual variable holding the user ID
// // // // //     List<Store> favoriteStores = await DatabaseHelper().getUserFavoriteStores(userId);
// // // // //     setState(() {
// // // // //       _favoriteStores = favoriteStores;
// // // // //     });
// // // // //   } catch (e) {
// // // // //     print('Error fetching favorite stores: $e');
// // // // //   }
// // // // // }



  
// // // // //   void _getFavoriteStoreLocation(int? storeId) async {
// // // // //   if (storeId != null) {
// // // // //     try {
// // // // //       Map<String, double> storeLocation =
// // // // //           await DatabaseHelper().getFavoriteStoreLocation(storeId);
// // // // //       print('Store Location: $storeLocation');
// // // // //       // Do something with the store location, such as calculating distance
// // // // //     } catch (e) {
// // // // //       print('Error fetching favorite store location: $e');
// // // // //     }
// // // // //   } else {
// // // // //     print('Invalid store ID');
// // // // //   }
// // // // // }

// // // // // }

// // // // // void main() {
// // // // //   runApp(MaterialApp(
// // // // //     home: LocationPage(),
// // // // //   ));
// // // // // }





// // // // // // Future<void> _fetchUserId() async {
// // // // // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // // // // //     userId = prefs.getInt('userId') ?? 0;
// // // // // //   }



// // // // // // Future<void> _fetchFavoriteStores() async {
// // // // //   //   try {
// // // // //   //     List<Store> userFavoriteStores =
// // // // //   //         await DatabaseHelper().getUserFavoriteStores(userId);
// // // // //   //     setState(() {
// // // // //   //       favoriteStores = userFavoriteStores;
// // // // //   //     });
// // // // //   //   } catch (e) {
// // // // //   //     print('Error fetching favorite stores: $e');
// // // // //   //   }
// // // // //   // }

// // // // //   // void _getFavoriteStoreLocation(int storeId) async {
// // // // //   //   try {
// // // // //   //     Map<String, double> storeLocation =
// // // // //   //         await DatabaseHelper().getFavoriteStoreLocation(storeId);
// // // // //   //     print('Store Location: $storeLocation');
// // // // //   //     // Do something with the store location, such as calculating distance
// // // // //   //   } catch (e) {
// // // // //   //     print('Error fetching favorite store location: $e');
// // // // //   //   }
// // // // //   // }







// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:geolocator/geolocator.dart';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:geolocator/geolocator.dart';
// // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // import 'package:stores_app/databaseHelper.dart';
// // // // // // import 'package:stores_app/store.dart';
// // // // // // import 'dart:math' as math;
// // // // // // class locationPage extends StatefulWidget {
// // // // // //   @override
// // // // // //     static String id = "location";

// // // // // //   _locationPageState createState() => _locationPageState();
// // // // // // }

// // // // // // class _locationPageState extends State<locationPage> {
// // // // // //   Position? _currentPosition; // Make _currentPosition nullable by adding '?' after Position

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       appBar: AppBar(
// // // // // //         title: Text('Finding the Location'),
// // // // // //                 backgroundColor: const Color(0xFF9A4253),

// // // // // //       ),
// // // // // //       body: Center(
// // // // // //         child: Column(
// // // // // //           // mainAxisAlignment: MainAxisAlignment.center,
// // // // // //           children: <Widget>[
// // // // // //             SizedBox(height: 25,),
// // // // // //             ElevatedButton(
// // // // // //               onPressed: () {
// // // // // //                 _getCurrentLocation();
// // // // // //               },
// // // // // //               child: Text('Get Current Location'),
// // // // // //               style: ElevatedButton.styleFrom(
// // // // // //                       fixedSize: const Size(360, 48),
// // // // // //                       backgroundColor: const Color(0xFF9A4253),
// // // // // //                       shape: RoundedRectangleBorder(
// // // // // //                         borderRadius: BorderRadius.circular(18.0),
// // // // // //                       ),
// // // // // //                     ),
// // // // // //             ),
// // // // // //             SizedBox(height: 15),

// // // // // //             _currentPosition != null
// // // // // //                 ? Text(
// // // // // //                     'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}')
// // // // // //                 : Text('Location not fetched yet'),
          
// // // // // //           ],
        
        
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   void _getCurrentLocation() async {
// // // // // //     final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
// // // // // //     Position position = await geolocator.getCurrentPosition(
// // // // // //         desiredAccuracy: LocationAccuracy.high);

// // // // // //     setState(() {
// // // // // //       _currentPosition = position;
// // // // // //     });
// // // // // //   }


// // // // // // }

// // // // // // void main() {
// // // // // //   runApp(MaterialApp(
// // // // // //     home: locationPage(),
// // // // // //   ));
// // // // // // }






  
// // // // //   // void _getCurrentLocationAndCalculateDistance(Store store) async {
// // // // //   //   final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
// // // // //   //   Position position = await geolocator.getCurrentPosition(
// // // // //   //       desiredAccuracy: LocationAccuracy.high);

// // // // //   //   setState(() {
// // // // //   //     _currentPosition = position;
// // // // //   //   });

// // // // //   //   if (_currentPosition != null) {
// // // // //   //     double distanceInMeters = calculateDistance(
// // // // //   //         _currentPosition!.latitude,
// // // // //   //         _currentPosition!.longitude,
// // // // //   //         store.latitude,
// // // // //   //         store.longitude);
// // // // //   //     // You can display the distance wherever you want, for example, in a dialog
// // // // //   //     showDialog(
// // // // //   //       context: context,
// // // // //   //       builder: (BuildContext context) {
// // // // //   //         return AlertDialog(
// // // // //   //           title: Text('Distance'),
// // // // //   //           content: Text(
// // // // //   //               'Distance to ${store.name}: ${distanceInMeters.toStringAsFixed(2)} meters'),
// // // // //   //           actions: <Widget>[
// // // // //   //             TextButton(
// // // // //   //               onPressed: () {
// // // // //   //                 Navigator.of(context).pop();
// // // // //   //               },
// // // // //   //               child: Text('Close'),
// // // // //   //             ),
// // // // //   //           ],
// // // // //   //         );
// // // // //   //       },
// // // // //   //     );
// // // // //   //   }
// // // // //   // }

// // // // //   // double calculateDistance(
// // // // //   //     double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
// // // // //   //   const int earthRadius = 6371000; // meters
// // // // //   //   double lat1 = _radians(startLatitude);
// // // // //   //   double lon1 = _radians(startLongitude);
// // // // //   //   double lat2 = _radians(endLatitude);
// // // // //   //   double lon2 = _radians(endLongitude);

// // // // //   //   double dLat = lat2 - lat1;
// // // // //   //   double dLon = lon2 - lon1;

// // // // //   //   double a = math.pow(math.sin(dLat / 2), 2) +
// // // // //   //       math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
// // // // //   //   double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

// // // // //   //   double distance = earthRadius * c;

// // // // //   //   return distance;
// // // // //   // }

// // // // //   // double _radians(double degrees) {
// // // // //   //   return degrees * (math.pi / 180);
// // // // //   // }
