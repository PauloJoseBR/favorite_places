import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;

  const PlaceLocation({required this.latitude, required this.longitude});
}

class Place {
  final String name;
  final File? image;
  final PlaceLocation? location;

  Place({required this.name, this.image, this.location});
}
