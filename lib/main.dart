import 'package:flutter/material.dart';
import 'package:foodfinder/views/main_screen.dart';

void main() {
  runApp(const foodfinder());
}

class foodfinder extends StatelessWidget {
  const foodfinder({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Main Screen',
        theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 74, 104, 112),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 42, 51, 59),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 130, 159, 167),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
 