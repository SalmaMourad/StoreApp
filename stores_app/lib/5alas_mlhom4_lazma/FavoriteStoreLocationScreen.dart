// import 'package:flutter/material.dart';
// import 'package:stores_app/databaseHelper.dart';

// class FavoriteStoreLocationScreen extends StatefulWidget {
//   final int userId;

//   const FavoriteStoreLocationScreen({Key? key, required this.userId}) : super(key: key);

//   @override
//   _FavoriteStoreLocationScreenState createState() => _FavoriteStoreLocationScreenState();
// }

// class _FavoriteStoreLocationScreenState extends State<FavoriteStoreLocationScreen> {
//   DatabaseHelper _databaseHelper = DatabaseHelper();
//   Map<String, dynamic>? _favoriteStoreLocation;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Favorite Store Location'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 _getFavoriteStoreLocation();
//               },
//               child: Text('Get Favorite Store Location'),
//             ),
//             SizedBox(height: 20),
//             if (_favoriteStoreLocation != null)
//               Text(
//                 'Latitude: ${_favoriteStoreLocation!['latitude']}, Longitude: ${_favoriteStoreLocation!['longitude']}',
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _getFavoriteStoreLocation() async {
//     try {
//       Map<String, dynamic>? location = await _databaseHelper.getFavoriteStoreLocation(widget.userId);
//       setState(() {
//         _favoriteStoreLocation = location;
//       });
//     } catch (e) {
//       // Handle error
//       print('Error getting favorite store location: $e');
//     }
//   }
// }

// // Usage:
// // In your widget tree, navigate to FavoriteStoreLocationScreen and pass the userId as a parameter.
