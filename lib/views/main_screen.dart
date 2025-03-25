import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:foodfinder/views/stream_location_screen.dart';
import 'package:foodfinder/views/select_destination_screen.dart';
import 'package:foodfinder/views/restaurant_list_screen.dart';
import 'package:foodfinder/services/geolocation_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String locationMessage = "Location not available";
  final GeolocationService _geoService = GeolocationService();

  // Get current location and update state.
  Future<void> getLocation() async {
    try {
      Position position = await _geoService.getCurrentPosition();
      setState(() {
        locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        locationMessage = "Error: $e";
      });
    }
  }

  void _gotoStreamLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StreamLocationScreen()),
    );
  }

  void _gotoSelectDestination() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectDestinationScreen()),
    );
  }
  
  void _gotoRestaurantList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RestaurantListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive layout using LayoutBuilder.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Small screen: Column layout.
          return Scaffold(
            appBar: AppBar(title: const Text('Foodie Finder')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(locationMessage),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: getLocation,
                    child: const Text('Get Current Location'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _gotoStreamLocation,
                    child: const Text('Live Location Updates'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _gotoSelectDestination,
                    child: const Text('Select Destination'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _gotoRestaurantList,
                    child: const Text('Restaurant List'),
                  ),
                ],
              ),
            ),
          );
        } else if (constraints.maxWidth < 1200) {
          // Medium screen: Row layout.
          return Scaffold(
            appBar: AppBar(title: const Text('Foodie Finder')),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(locationMessage),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: getLocation,
                        child: const Text('Get Current Location'),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _gotoStreamLocation,
                        child: const Text('Live Location Updates'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _gotoSelectDestination,
                        child: const Text('Select Destination'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _gotoRestaurantList,
                        child: const Text('Restaurant List'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          // Large screen: Grid layout.
          return Scaffold(
            appBar: AppBar(title: const Text('Foodie Finder')),
            body: Center(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  Container(
                    color: Colors.orange[50],
                    child: Center(child: Text(locationMessage)),
                  ),
                  ElevatedButton(
                    onPressed: getLocation,
                    child: const Text('Get Current Location'),
                  ),
                  ElevatedButton(
                    onPressed: _gotoStreamLocation,
                    child: const Text('Live Location Updates'),
                  ),
                  ElevatedButton(
                    onPressed: _gotoSelectDestination,
                    child: const Text('Select Destination'),
                  ),
                  ElevatedButton(
                    onPressed: _gotoRestaurantList,
                    child: const Text('Restaurant List'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
