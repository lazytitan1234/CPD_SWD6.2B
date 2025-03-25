import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  // Fetch the current location and update the state.
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

  // Trigger a test local notification.
  Future<void> sendTestNotification() async {
    await _notificationService.scheduleNotification("Test Notification", "This is a test notification.", 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Foodie Finder - Test Notifications"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locationMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getLocation,
              child: const Text("Get Current Location"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendTestNotification,
              child: const Text("Send Test Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
