import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/restaurant.dart';
import '../services/geolocation_service.dart';

class SelectDestinationScreen extends StatefulWidget {
  const SelectDestinationScreen({super.key});

  @override
  _SelectDestinationScreenState createState() => _SelectDestinationScreenState();
}

class _SelectDestinationScreenState extends State<SelectDestinationScreen> {
  final GeolocationService _geoService = GeolocationService();
  double? _distance;
  Restaurant? _selectedRestaurant;
  Position? _currentPosition;

  // List of default restaurants.
  final List<Restaurant> _restaurants = [
    Restaurant(name: "Mcdonals", latitude: 312.321341, longitude: -31.9321312),
    Restaurant(name: "Point de view", latitude: 200.65489, longitude: -98.89485),
    Restaurant(name: "KFC", latitude: 82.9898, longitude: -69.1234567),
  ];

  // Calculate the distance from the current location to the selected restaurant.
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
        title: const Text("Select a Destination"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = _restaurants[index];
                return ListTile(
                  title: Text(restaurant.name),
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
      ),
    );
  }
}
