import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({super.key});

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredLatitude = '';
  var _enteredLongitude = '';
  var isSendingData = false;

  void _saveRestaurant() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isSendingData = true;
      });

      final url = Uri.https(
        'foodfinder-5553f-default-rtdb.europe-west1.firebasedatabase.app',
        'restaurants.json',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _enteredName,
          'latitude': double.parse(_enteredLatitude),
          'longitude': double.parse(_enteredLongitude),
        }),
      );

      if (!mounted) return;

      Navigator.of(context).pop(); // go back to list screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Restaurant')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _enteredName = value!,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _enteredLatitude = value!,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Enter valid latitude';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _enteredLongitude = value!,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Enter valid longitude';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
