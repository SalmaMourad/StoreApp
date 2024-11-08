import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stores_app/5alas_mlhom4_lazma/LocationPage22/loca2.dart';
import 'package:stores_app/LocationPage/location_page.dart';
import 'package:stores_app/Stores/store.dart';
import 'package:stores_app/FavoriteList/FavoriteListPage.dart';
import 'package:stores_app/Stores/stores_provider.dart'; // Import the StoresProvider class

class StoresScreen extends StatelessWidget {
  static const String id = "store";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9A4253),
        title: const Text('All Stores'),
      ),
      body: Consumer<StoresProvider>(
        builder: (context, storesProvider, _) => Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteListPage(),
                  ),
                );
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF9A4253),
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                alignment: Alignment.center,
                child: Text(
                  'Go to Favorite List',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, LocationPage.id);
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF9A4253),
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                alignment: Alignment.center,
                child: Text(
                  'Find Location',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: storesProvider.stores.length,
                itemBuilder: (context, index) {
                  return StoreCard(
                    store: storesProvider.stores[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  final Store store;

  const StoreCard({
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Image.asset(
            'lib/assets/images/store1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
          ListTile(
            title: Text(store.name),
            subtitle: Text(
              'Latitude: ${store.latitude}, Longitude: ${store.longitude}',
            ),
            trailing: IconButton(
              icon: Icon(
                store.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: store.isFavorite ? Colors.red : null,
              ),
              onPressed: () async {
                if (store.isFavorite) {
                  print('Removing store from favorites...');
                  await Provider.of<StoresProvider>(context, listen: false)
                      .removeFavorite(store);
                  print('Store removed from favorites');
                } else {
                  print('Adding store to favorites...');
                  await Provider.of<StoresProvider>(context, listen: false)
                      .addFavorite(store);
                  print('Store added to favorites');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
