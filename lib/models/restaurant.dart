class Restaurant {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  Restaurant({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Restaurant.fromMap(Map<dynamic, dynamic> data) {
    return Restaurant(
      id: data['id'] as String,
      name: data['name'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
    );
  }
}
