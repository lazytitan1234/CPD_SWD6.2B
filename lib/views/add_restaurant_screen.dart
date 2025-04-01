import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodfinder/services/notification_service.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({super.key});

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = '';
  String _latitude = '';
  String _longitude = '';
  bool isSendingData = false;
  bool manualInput = false;
  bool isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
        isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLocation = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }
  }

  Future<void> _saveRestaurant() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      isSendingData = true;
    });

    final url = Uri.https(
      'foodfinder-5553f-default-rtdb.europe-west1.firebasedatabase.app',
      'restaurants.json',
    );

    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _enteredName,
        'latitude': double.parse(_latitude),
        'longitude': double.parse(_longitude),
      }),
    );

    if (!mounted) return;

    //  Respect mute setting before showing notification
    final prefs = await SharedPreferences.getInstance();
    final isMuted = prefs.getBool('notificationsMuted') ?? false;

    if (!isMuted) {
      await NotificationService().showNow(
        'Restaurant Added',
        '$_enteredName was added successfully!',
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Restaurant added successfully!')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final locationFields = Column(
      children: [
        TextFormField(
          initialValue: _latitude,
          enabled: manualInput,
          decoration: const InputDecoration(labelText: 'Latitude'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || double.tryParse(value) == null) {
              return 'Enter a valid latitude';
            }
            return null;
          },
          onSaved: (value) => _latitude = value!,
        ),
        TextFormField(
          initialValue: _longitude,
          enabled: manualInput,
          decoration: const InputDecoration(labelText: 'Longitude'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || double.tryParse(value) == null) {
              return 'Enter a valid longitude';
            }
            return null;
          },
          onSaved: (value) => _longitude = value!,
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Add Restaurant')),
      body: isLoadingLocation
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Restaurant Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      onSaved: (value) => _enteredName = value!,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Use Manual Location Input'),
                        Switch(
                          value: manualInput,
                          onChanged: (value) {
                            setState(() {
                              manualInput = value;
                            });
                          },
                        ),
                      ],
                    ),
                    locationFields,
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isSendingData ? null : _saveRestaurant,
                      child: isSendingData
                          ? const CircularProgressIndicator()
                          : const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
