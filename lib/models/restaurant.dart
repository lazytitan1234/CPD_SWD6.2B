class Restaurant {
  final String name;
  final double latitude;
  final double longitude;

  Restaurant({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  // Create a Restaurant from a Map (e.g., from Firebase)
  factory Restaurant.fromMap(Map<dynamic, dynamic> data) {
    return Restaurant(
      name: data['name'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
    );
  }
}
