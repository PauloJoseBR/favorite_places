import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;

  const PlaceLocation({required this.latitude, required this.longitude});
}

class Place {
  final int? id;
  final String name;
  final String? imagePath;
  final PlaceLocation? location;

  Place({this.id, required this.name, this.imagePath, this.location});

  File? get image => imagePath != null ? File(imagePath!) : null;

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'image_path': imagePath,
    'latitude': location?.latitude,
    'longitude': location?.longitude,
  };

  factory Place.fromMap(Map<String, dynamic> map) => Place(
    id: map['id'] as int?,
    name: map['name'] as String,
    imagePath: map['image_path'] as String?,
    location: map['latitude'] != null
        ? PlaceLocation(
            latitude: map['latitude'] as double,
            longitude: map['longitude'] as double,
          )
        : null,
  );
}
