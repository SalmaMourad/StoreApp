import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stores_app/LocationPage/location_provider.dart';

class LocationPage extends StatefulWidget {
  static const String id = "location";

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).fetchFavoriteStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finding the Location'),
        backgroundColor: const Color(0xFF9A4253),
      ),
      body: Center(
        child: Consumer<LocationProvider>(
          builder: (context, provider, _) {
            return Column(
              children: <Widget>[
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    provider.getCurrentLocation();
                  },
                  child: Text('Get Current Location',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(360, 48),
                    backgroundColor: const Color(0xFF9A4253),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                provider.currentPosition != null
                    ? Text(
                        'Current Location: Latitude: ${provider.currentPosition!.latitude}, Longitude: ${provider.currentPosition!.longitude}')
                    : Text('Location not fetched yet'),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    _showStoreList(context, provider);
                  },
                  child: Text('Choose Favorite Store',style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(360, 48),
                    backgroundColor: const Color(0xFF9A4253),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                provider.selectedStoreLocation != null
                    ? Text(
                        'Selected Store Location: Latitude: ${provider.selectedStoreLocation!['latitude']}, Longitude: ${provider.selectedStoreLocation!['longitude']}')
                    : Text('No store selected'),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    provider.calculateDistance();
                  },
                  child: Text('Calculate Distance',style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(360, 48),
                    backgroundColor: const Color(0xFF9A4253),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                provider.distanceToStore != 0.0
                    ? Text('Distance to store: ${provider.distanceToStore} km')
                    : SizedBox(),
                SizedBox(height: 15),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showStoreList(BuildContext context, LocationProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          builder: (context, scrollController) {
            return ListView.builder(
              controller: scrollController,
              itemCount: provider.favoriteStores.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(provider.favoriteStores[index].name),
                  onTap: () {
                    Navigator.pop(context);
                    provider.getFavoriteStoreLocation(
                        provider.favoriteStores[index]);
                  },
                );
              },
            );
          },
          initialChildSize: 0.5,
          minChildSize: 0.25,
          maxChildSize: 0.8,
        );
      },
    );
  }
}
