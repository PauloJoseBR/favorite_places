import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:favorite_places/models/place.dart';

class PlacesDatabase {
  static final PlacesDatabase instance = PlacesDatabase._();
  PlacesDatabase._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      p.join(dbPath, 'places.db'),
      version: 1,
      onCreate: (db, _) => db.execute('''
        CREATE TABLE places (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          image_path TEXT,
          latitude REAL,
          longitude REAL
        )
      '''),
    );
  }

  /// Copies the temp image file into permanent app storage and returns the new path.
  Future<String> saveImagePermanently(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(image.path);
    final permanent = await image.copy('${appDir.path}/$fileName');
    return permanent.path;
  }

  Future<Place> insertPlace(Place place) async {
    final db = await database;
    final id = await db.insert('places', place.toMap());
    return Place(
      id: id,
      name: place.name,
      imagePath: place.imagePath,
      location: place.location,
    );
  }

  Future<List<Place>> fetchAllPlaces() async {
    final db = await database;
    final rows = await db.query('places', orderBy: 'id DESC');
    return rows.map(Place.fromMap).toList();
  }

  Future<void> deletePlace(int id) async {
    final db = await database;
    await db.delete('places', where: 'id = ?', whereArgs: [id]);
  }
}
