import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:foodfinder/views/stream_location_screen.dart';
import 'package:foodfinder/views/select_destination_screen.dart';
import 'package:foodfinder/views/restaurant_list_screen.dart';
import 'package:foodfinder/views/add_restaurant_screen.dart';
import 'package:foodfinder/services/geolocation_service.dart';
import 'package:foodfinder/services/notification_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String locationMessage = "Location not available";
  final GeolocationService _geoService = GeolocationService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
  }

  Future<void> getLocation() async {
    try {
      Position position = await _geoService.getCurrentPosition();
      setState(() {
        locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
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

  void _gotoAddRestaurant() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRestaurantScreen()),
    );
  }

  void _sendTestNotification() {
    _notificationService.scheduleNotification(
      'Food Alert',
      'Time to check out a new restaurant!',
      5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foodie Finder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _sendTestNotification,
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 600;
          final isMedium = constraints.maxWidth < 1200;

          final children = [
            Card(
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(locationMessage),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.my_location),
                      label: const Text('Get Current Location'),
                      onPressed: getLocation,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.gps_fixed),
              label: const Text('Live Location Updates'),
              onPressed: _gotoStreamLocation,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.place),
              label: const Text('Select Destination'),
              onPressed: _gotoSelectDestination,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Restaurant List'),
              onPressed: _gotoRestaurantList,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_business),
              label: const Text('Add Restaurant'),
              onPressed: _gotoAddRestaurant,
            ),
          ];

          if (isSmall) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              ),
            );
          } else if (isMedium) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children.sublist(0, 2),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children.sublist(2),
                  ),
                ],
              ),
            );
          } else {
            return GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: children,
            );
          }
        },
      ),
    );
  }
}
