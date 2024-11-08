// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stores_app/databaseHelper.dart';
// import 'package:stores_app/store.dart';
// import 'dart:math' as math;
// class locationPage extends StatefulWidget {
//   @override
//     static String id = "location";

//   _locationPageState createState() => _locationPageState();
// }

// class _locationPageState extends State<locationPage> {
//   Position? _currentPosition; // Make _currentPosition nullable by adding '?' after Position

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Finding the Location'),
//                 backgroundColor: const Color(0xFF9A4253),

//       ),
//       body: Center(
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(height: 25,),
//             ElevatedButton(
//               onPressed: () {
//                 _getCurrentLocation();
//               },
//               child: Text('Get Current Location'),
//               style: ElevatedButton.styleFrom(
//                       fixedSize: const Size(360, 48),
//                       backgroundColor: const Color(0xFF9A4253),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18.0),
//                       ),
//                     ),
//             ),
//             SizedBox(height: 15),

//             _currentPosition != null
//                 ? Text(
//                     'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}')
//                 : Text('Location not fetched yet'),
          
//           // ElevatedButton(
//           //                   onPressed: () {
//           //                     _getCurrentLocationAndCalculateDistance(
//           //                         favoriteStores[index]);
//           //                   },
//           //                   child: Text('Calculate Distance'),
//           //                 ),
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


  
//   void _getCurrentLocationAndCalculateDistance(Store store) async {
//     final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
//     Position position = await geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       _currentPosition = position;
//     });

//     if (_currentPosition != null) {
//       double distanceInMeters = calculateDistance(
//           _currentPosition!.latitude,
//           _currentPosition!.longitude,
//           store.latitude,
//           store.longitude);
//       // You can display the distance wherever you want, for example, in a dialog
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Distance'),
//             content: Text(
//                 'Distance to ${store.name}: ${distanceInMeters.toStringAsFixed(2)} meters'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Close'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   double calculateDistance(
//       double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
//     const int earthRadius = 6371000; // meters
//     double lat1 = _radians(startLatitude);
//     double lon1 = _radians(startLongitude);
//     double lat2 = _radians(endLatitude);
//     double lon2 = _radians(endLongitude);

//     double dLat = lat2 - lat1;
//     double dLon = lon2 - lon1;

//     double a = math.pow(math.sin(dLat / 2), 2) +
//         math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
//     double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

//     double distance = earthRadius * c;

//     return distance;
//   }

//   double _radians(double degrees) {
//     return degrees * (math.pi / 180);
//   }

// }

// void main() {
//   runApp(MaterialApp(
//     home: locationPage(),
//   ));
// }
