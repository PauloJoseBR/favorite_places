import 'package:flutter/material.dart';
import 'package:favorite_places/screens/places_screen.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color(0xFF2E6E65),
  surface: const Color(0xFFF6F4EF),
);

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  scaffoldBackgroundColor: colorScheme.surface,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Great Places',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const PlacesScreen(),
    );
  }
}
