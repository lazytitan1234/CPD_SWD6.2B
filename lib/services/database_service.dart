import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class DatabaseService {
  final String baseUrl = 'foodfinder-5553f-default-rtdb.europe-west1.firebasedatabase.app';

  Future<void> addRestaurant(Restaurant restaurant) async {
    final url = Uri.https(baseUrl, 'restaurants.json');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': restaurant.name,
        'latitude': restaurant.latitude,
        'longitude': restaurant.longitude,
      }),
    );
  }

  Future<List<Restaurant>> fetchRestaurants() async {
  final url = Uri.https(baseUrl, 'restaurants.json');
  final response = await http.get(url);

  final decoded = json.decode(response.body);
  if (decoded == null) return [];

  final Map<String, dynamic> data = decoded as Map<String, dynamic>;
  final List<Restaurant> loadedRestaurants = [];

  for (final entry in data.entries) {
    final value = entry.value;
    loadedRestaurants.add(
      Restaurant(
        name: value['name'],
        latitude: (value['latitude'] as num).toDouble(),
        longitude: (value['longitude'] as num).toDouble(),
      ),
    );
  }

  return loadedRestaurants;
  }
}
