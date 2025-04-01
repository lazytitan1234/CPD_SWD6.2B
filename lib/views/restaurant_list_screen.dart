import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/restaurant.dart';
import '../services/database_service.dart';
import '../services/geolocation_service.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final DatabaseService _dbService = DatabaseService();
  final GeolocationService _geoService = GeolocationService();
  Position? _currentPosition;
  double? _distance;
  Restaurant? _selectedRestaurant;
  late Future<List<Restaurant>> _restaurantFuture;

  @override
  void initState() {
    super.initState();
    _restaurantFuture = _dbService.fetchRestaurants();
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error calculating distance: $e")),
      );
    }
  }

  void _refreshRestaurants() {
    setState(() {
      _restaurantFuture = _dbService.fetchRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshRestaurants,
          )
        ],
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: _restaurantFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final restaurants = snapshot.data;

          if (restaurants == null || restaurants.isEmpty) {
            return const Center(child: Text("No restaurants found."));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return Dismissible(
                      key: Key(restaurant.id ?? restaurant.name),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        await _dbService.deleteRestaurant(restaurant.id!);
                        _refreshRestaurants();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${restaurant.name} deleted')),
                        );
                      },
                      child: ListTile(
                        title: Text(restaurant.name),
                        subtitle: Text("Lat: ${restaurant.latitude}, Lon: ${restaurant.longitude}"),
                        onTap: () => _calculateDistance(restaurant),
                      ),
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
        },
      ),
    );
  }
}
