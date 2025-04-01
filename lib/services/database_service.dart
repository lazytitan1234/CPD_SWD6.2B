import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class DatabaseService {
  final String baseUrl = 'foodfinder-5553f-default-rtdb.europe-west1.firebasedatabase.app';

  Future<void> deleteRestaurant(String id) async {
    final url = Uri.https(baseUrl, 'restaurants/$id.json');
    await http.delete(url);
  }

  Future<List<Restaurant>> fetchRestaurants() async {
    final url = Uri.https(baseUrl, 'restaurants.json');
    final response = await http.get(url);

    final decoded = json.decode(response.body);
    if (decoded == null || decoded == 'null' || decoded is! Map<String, dynamic>) {
      return [];
    }

    final Map<String, dynamic> data = decoded;
    final List<Restaurant> loadedRestaurants = [];

    for (final entry in data.entries) {
      final id = entry.key;
      final value = entry.value;
      loadedRestaurants.add(
        Restaurant(
          id: id,
          name: value['name'],
          latitude: (value['latitude'] as num).toDouble(),
          longitude: (value['longitude'] as num).toDouble(),
        ),
      );
    }

    return loadedRestaurants;
  }
}
