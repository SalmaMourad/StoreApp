
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stores_app/FavoriteList/FavoriteListPage.dart';
// import 'package:stores_app/locationPage/locationPage.dart';
import 'package:stores_app/LocationPage/location_provider.dart';
import 'package:stores_app/signUp_LoginPage/LoginPage.dart';
import 'package:stores_app/signUp_LoginPage/newSignUpPage.dart';
import 'package:stores_app/Stores/storesScreen.dart';
import 'package:stores_app/Stores/stores_provider.dart';
import 'package:stores_app/FavoriteList/FavoriteListProvider.dart';

import 'LocationPage/location_page.dart';

void main() async {
  runApp(const MobileApp());
}

class MobileApp extends StatelessWidget {
  const MobileApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StoresProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(), // Add LocationProvider here
        ),
      ],
      child: MaterialApp(
        routes: {
          LoginPage.id: (context) => LoginPage(),
          SignUpPagee.id: (context) => const SignUpPagee(),
          StoresScreen.id: (context) => StoresScreen(),
          FavoriteListPage.id: (context) => FavoriteListPage(),
          LocationPage.id: (context) => LocationPage(),
        },
        initialRoute: LoginPage.id,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'storesScreen.dart'; // Import the file where StoresScreen is defined

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Stores',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//         scrollbarTheme: ScrollbarThemeData(
//           thumbColor: MaterialStateProperty.all(Colors.green), // Change thumb color
//           trackColor: MaterialStateProperty.all(Colors.red), // Change track color
//         ),
//       ),
//       home: StoresScreen(), // Set StoresScreen as the home screen
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
