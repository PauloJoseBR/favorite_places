import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:favorite_places/screens/places_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Places',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4FACFE),
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF0A0E1A),
          primary: const Color(0xFF4FACFE),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0E1A),
      ),
      debugShowCheckedModeBanner: false,
      home: const PlacesScreen(),
    );
  }
}
