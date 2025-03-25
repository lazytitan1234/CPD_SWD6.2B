import 'package:flutter/material.dart';
import 'package:foodfinder/views/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
    home: MainScreen(),
  ));
}
