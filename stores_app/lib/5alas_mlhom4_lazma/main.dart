// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stores_app/FavoriteListPage.dart';
// import 'package:stores_app/locationPage/locationPage.dart';
// import 'package:stores_app/location_provider.dart';
// import 'package:stores_app/signUpPageAndLoginPage/LoginPage.dart';
// import 'package:stores_app/signUpPageAndLoginPage/newSignUpPage.dart';
// import 'package:stores_app/storesScreen.dart';
// import 'package:stores_app/stores_provider.dart';
// import 'package:stores_app/FavoriteListProvider.dart';

// import '../location_page.dart';

// void main() async {
//   runApp(const MobileApp());
// }

// class MobileApp extends StatelessWidget {
//   const MobileApp();

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => StoresProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => FavoriteListProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => LocationProvider(), // Add LocationProvider here
//         ),
//       ],
//       child: MaterialApp(
//         routes: {
//           LoginPage.id: (context) => LoginPage(),
//           SignUpPagee.id: (context) => const SignUpPagee(),
//           StoresScreen.id: (context) => StoresScreen(),
//           FavoriteListPage.id: (context) => FavoriteListPage(),
//           LocationPage.id: (context) => LocationPage(),
//         },
//         initialRoute: LoginPage.id,
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }






// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:stores_app/FavoriteListPage.dart';
// // import 'package:stores_app/LocationPage22/loca2.dart';
// // // import 'package:stores_app/LocationPage/l.dart';
// // import 'package:stores_app/locationPage/locationPage.dart';
// // import 'package:stores_app/location_page.dart';
// // import 'package:stores_app/location_provider.dart';
// // import 'package:stores_app/signUpPageAndLoginPage/LoginPage.dart';
// // import 'package:stores_app/signUpPageAndLoginPage/newSignUpPage.dart';
// // import 'package:stores_app/storesScreen.dart';
// // import 'package:stores_app/stores_provider.dart'; // Import the StoresProvider class
// // import 'package:stores_app/FavoriteListProvider.dart'; // Import the FavoriteListProvider class

// // void main() async {
// //   runApp(const MobileApp());
// // }

// // class MobileApp extends StatelessWidget {
// //   const MobileApp();

// //   @override
// //   Widget build(BuildContext context) {

// //     return MultiProvider(
// //       providers: [
// //         ChangeNotifierProvider(
// //           create: (context) => StoresProvider(), // Provide the StoresProvider
// //         ),
// //         ChangeNotifierProvider(
// //           create: (context) =>
// //               FavoriteListProvider(), // Provide the FavoriteListProvider
// //         ),
// //         ChangeNotifierProvider(
// //       create: (context) => LocationProvider(),)
// //       ],
// //       child: MaterialApp(
// //         routes: {
// //           LoginPage.id: (context) => LoginPage(),
// //           SignUpPagee.id: (context) => const SignUpPagee(),
// //           StoresScreen.id: (context) => StoresScreen(),
// //           FavoriteListPage.id: (context) => FavoriteListPage(),
// //           LocationPage.id: (context) => LocationPage(),
// //         },
// //         initialRoute: LoginPage.id,
// //         debugShowCheckedModeBanner: false,
// //       ),
// //     );
// //   }
// // }


// // // <<<<<<< HEAD
// // //     return MaterialApp(
// // //       routes: {
// // //         LoginPage.id: (context) => LoginPage(),
// // //         SignUpPagee.id: (context) => const SignUpPagee(),
// // //         StoresScreen.id: (context) => StoresScreen(),
// // //         FavoriteListPage.id: (context) => FavoriteListPage(),
// // //         LocationPage.id:(context) => LocationPage(),
// // //       },
// // //       initialRoute: LoginPage.id,
// // //       debugShowCheckedModeBanner: false,
// // // =======