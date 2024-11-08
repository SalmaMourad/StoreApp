import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stores_app/FavoriteList/FavoriteListProvider.dart';
import 'package:stores_app/Stores/store.dart';

class FavoriteListPage extends StatefulWidget {
  static const String id = "FavoriteListPage";

  @override
  _FavoriteListPageState createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<FavoriteListProvider>(context, listen: false)
        .fetchFavoriteStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Stores'),
        backgroundColor: const Color(0xFF9A4253),
      ),
      body: Consumer<FavoriteListProvider>(
        builder: (context, provider, _) {
          if (provider.favoriteStores.isEmpty) {
            return Center(
              child: Text('No favorite stores yet'),
            );
          } else {
            return ListView.builder(
              itemCount: provider.favoriteStores.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: Card(
                      child: ListTile(
                        title: Text(provider.favoriteStores[index].name),
                        subtitle: Text(
                            'Latitude: ${provider.favoriteStores[index].latitude}, Longitude: ${provider.favoriteStores[index].longitude}'),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
