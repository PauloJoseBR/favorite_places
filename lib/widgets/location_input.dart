import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:favorite_places/models/place.dart';

class LocationInput extends StatefulWidget {
  final void Function(PlaceLocation location) onSelectLocation;

  const LocationInput({super.key, required this.onSelectLocation});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    final locationService = Location();

    bool serviceEnabled = await locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationService.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permission = await locationService.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await locationService.requestPermission();
      if (permission != PermissionStatus.granted) return;
    }

    setState(() => _isLoading = true);

    try {
      final data = await locationService.getLocation();
      if (data.latitude == null || data.longitude == null) {
        setState(() => _isLoading = false);
        return;
      }

      final picked = PlaceLocation(
        latitude: data.latitude!,
        longitude: data.longitude!,
      );

      setState(() {
        _pickedLocation = picked;
        _isLoading = false;
      });

      widget.onSelectLocation(picked);
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent;

    if (_isLoading) {
      previewContent = const Center(
        child: CircularProgressIndicator(color: Color(0xFF1D5A52)),
      );
    } else if (_pickedLocation != null) {
      final point = LatLng(
        _pickedLocation!.latitude,
        _pickedLocation!.longitude,
      );
      previewContent = Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: point,
              initialZoom: 16,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.favorite_places',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: point,
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              color: Colors.black54,
              child: Text(
                '${_pickedLocation!.latitude.toStringAsFixed(5)}, '
                '${_pickedLocation!.longitude.toStringAsFixed(5)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      previewContent = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on_outlined, size: 48, color: Color(0xFF5A8A83)),
          SizedBox(height: 10),
          Text(
            'No location selected yet.',
            style: TextStyle(
              color: Color(0xFF5A8A83),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withValues(alpha: 0.6),
          ),
          clipBehavior: Clip.hardEdge,
          child: previewContent,
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _isLoading ? null : _getCurrentLocation,
          icon: const Icon(Icons.my_location_rounded, size: 18),
          label: const Text('Get Current Location'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1D5A52),
            side: const BorderSide(color: Color(0xFF1D5A52)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
