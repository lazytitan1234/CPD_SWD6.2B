import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import '../models/restaurant.dart';

class DatabaseService {
  // Reference to the "restaurants" node using the Firebase SDK.
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("restaurants");

  // Base URL for your Firebase Realtime Database.
  final String _baseUrl = 'foodfinder-5553f-default-rtdb.europe-west1.firebasedatabase.app';

  // Add a new restaurant to the database using an HTTP POST request.
  Future<Map<String, dynamic>> addRestaurant(Restaurant restaurant) async {
    final url = Uri.https(_baseUrl, 'restaurants.json');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': restaurant.name,
        'latitude': restaurant.latitude,
        'longitude': restaurant.longitude,
      }),
    );

    // Decode the response which contains the generated key.
    return json.decode(response.body) as Map<String, dynamic>;
  }

  // Alternatively, you can add a restaurant using the Firebase SDK:
  Future<void> addRestaurantSDK(Restaurant restaurant) async {
    await _dbRef.push().set({
      'name': restaurant.name,
      'latitude': restaurant.latitude,
      'longitude': restaurant.longitude,
    });
  }

  // Get a stream of restaurant data from the Firebase Realtime Database.
  Stream<DatabaseEvent> getRestaurantsStream() {
    return _dbRef.onValue;
  }
}
