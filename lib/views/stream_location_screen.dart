import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/geolocation_service.dart';

class StreamLocationScreen extends StatefulWidget {
  const StreamLocationScreen({super.key});

  @override
  StreamLocationScreenState createState() => StreamLocationScreenState();
}

class StreamLocationScreenState extends State<StreamLocationScreen> {
  String locationMessage = "Listening for location updates...";
  final GeolocationService _geoService = GeolocationService();

  @override
  void initState() {
    super.initState();
    listenToLocationUpdates();
  }

  // Listen to live location updates.
  void listenToLocationUpdates() {
    _geoService.getLocationStream().listen((Position position) {
      setState(() {
        locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location Updates'),
      ),
      body: Center(
        child: Text(
          locationMessage,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
