import 'package:firebase_database/firebase_database.dart';
import '../models/restaurant.dart';

class DatabaseService {
  // Reference to the "restaurants" node in Firebase Realtime Database.
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("restaurants");

  // Add a new restaurant to the database.
  Future<void> addRestaurant(Restaurant restaurant) async {
    await _dbRef.push().set({
      'name': restaurant.name,
      'latitude': restaurant.latitude,
      'longitude': restaurant.longitude,
    });
  }

  // Get a stream of restaurant data.
  Stream<DatabaseEvent> getRestaurantsStream() {
    return _dbRef.onValue;
  }
}
