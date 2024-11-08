class Store {
  int? id;
  final String name;
  final double latitude;
  final double longitude;
  bool isFavorite;

  Store({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.id,
    this.isFavorite = false, // Default value for isFavorite
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    final name = map['name'];
    final latitude = map['latitude'];
    final longitude = map['longitude'];

    if (name == null || latitude == null || longitude == null) {
      throw ArgumentError("Invalid store data: $map");
    }

    return Store(
      id: map['id'],
      name: name,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
