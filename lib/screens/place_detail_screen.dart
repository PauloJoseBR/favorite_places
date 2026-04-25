import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;

  const PlaceDetailScreen({super.key, required this.place});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF183F3B),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Image
              if (place.image != null)
                Hero(
                  tag: place.name,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x330E312C),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.file(
                      place.image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                )
              else
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCEE2E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      size: 60,
                      color: Color(0xFF5A8A83),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              // Place name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  place.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF183F3B),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              // Location map
              if (place.location != null) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.network(
                          'https://staticmap.openstreetmap.de/staticmap.php'
                          '?center=${place.location!.latitude},${place.location!.longitude}'
                          '&zoom=16&size=600x220'
                          '&markers=${place.location!.latitude},${place.location!.longitude},red-pushpin',
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) =>
                              progress == null
                              ? child
                              : const SizedBox(
                                  height: 160,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF1D5A52),
                                    ),
                                  ),
                                ),
                          errorBuilder: (_, __, ___) => const SizedBox(
                            height: 160,
                            child: Center(
                              child: Icon(
                                Icons.map_outlined,
                                size: 40,
                                color: Color(0xFF5A8A83),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            color: Colors.black54,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${place.location!.latitude.toStringAsFixed(5)}, '
                                  '${place.location!.longitude.toStringAsFixed(5)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
