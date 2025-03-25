import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/restaurant.dart';
import '../services/database_service.dart';
import '../services/geolocation_service.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final DatabaseService _dbService = DatabaseService();
  final GeolocationService _geoService = GeolocationService();
  Position? _currentPosition;
  double? _distance;
  Restaurant? _selectedRestaurant;

  // Calculate distance from current location to selected restaurant.
  Future<void> _calculateDistance(Restaurant restaurant) async {
    try {
      _currentPosition = await _geoService.getCurrentPosition();
      double distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        restaurant.latitude,
        restaurant.longitude,
      );
      setState(() {
        _selectedRestaurant = restaurant;
        _distance = distanceInMeters;
      });
    } catch (e) {
      setState(() {
        _distance = null;
      });
      print("Error calculating distance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant List"),
      ),
      body: StreamBuilder(
        stream: _dbService.getRestaurantsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            final List<Restaurant> restaurants = data.entries.map((entry) {
              return Restaurant.fromMap(entry.value);
            }).toList();

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];
                      return ListTile(
                        title: Text(restaurant.name),
                        subtitle: Text("Lat: ${restaurant.latitude}, Lon: ${restaurant.longitude}"),
                        onTap: () => _calculateDistance(restaurant),
                      );
                    },
                  ),
                ),
                if (_distance != null && _selectedRestaurant != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Distance to ${_selectedRestaurant!.name}: ${(_distance! / 1000).toStringAsFixed(2)} km",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
