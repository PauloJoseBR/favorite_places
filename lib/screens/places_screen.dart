import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/add_place_screen.dart';
import 'package:favorite_places/screens/place_detail_screen.dart';
import 'package:favorite_places/services/places_database.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final _places = <Place>[];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    final places = await PlacesDatabase.instance.fetchAllPlaces();
    setState(() {
      _places
        ..clear()
        ..addAll(places);
    });
  }

  Future<void> _openAddPlace() async {
    final place = await Navigator.of(
      context,
    ).push<Place>(MaterialPageRoute(builder: (_) => const AddPlaceScreen()));
    if (place == null) return;
    setState(() => _places.insert(0, place));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF2E8CF), Color(0xFFDBE8D8), Color(0xFFCEE2E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Favorite Places',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  color: const Color(0xFF183F3B),
                                  fontSize: 40,
                                ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Save the places you love most.',
                            style: TextStyle(
                              color: Color(0xFF37534D),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: _openAddPlace,
                      backgroundColor: const Color(0xFF1D5A52),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      child: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _places.isEmpty
                        ? const Center(
                            child: Text(
                              'No favorite places yet.',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF385A54),
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.separated(
                            key: const ValueKey('places-list'),
                            itemCount: _places.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final place = _places[index];
                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: 1),
                                duration: Duration(
                                  milliseconds: 240 + (index * 60),
                                ),
                                curve: Curves.easeOut,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 12 * (1 - value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PlaceDetailScreen(place: place),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.78,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: place.image != null
                                              ? Image.file(
                                                  place.image!,
                                                  width: 56,
                                                  height: 56,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  width: 56,
                                                  height: 56,
                                                  color: const Color(
                                                    0xFFCEE2E0,
                                                  ),
                                                  child: const Icon(
                                                    Icons.place_rounded,
                                                    color: Color(0xFF1E5B53),
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            place.name,
                                            style: const TextStyle(
                                              color: Color(0xFF203933),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right_rounded,
                                          color: Color(0xFF37534D),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
