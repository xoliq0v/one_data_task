import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/tracking_session.dart';
import '../models/location_model.dart';
import '../../presentation/bloc/location_state.dart';
import '../../domain/entities/location.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('location_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE locations(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      speed REAL NOT NULL,
      timestamp INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE user_settings(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      measure_unit TEXT NOT NULL,
      tracking_interval INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE tracking_sessions(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      start_time INTEGER NOT NULL,
      end_time INTEGER,
      distance REAL NOT NULL,
      max_speed REAL NOT NULL,
      waiting_time INTEGER NOT NULL
    )
    ''');
  }

  Future<void> saveTrackingSession(TrackingSession session) async {
    final db = await database;
    await db.insert('tracking_sessions', {
      'start_time': session.startTime.millisecondsSinceEpoch,
      'end_time': session.endTime?.millisecondsSinceEpoch,
      'distance': session.distance,
      'max_speed': session.maxSpeed,
      'waiting_time': session.waitingTime.inSeconds,
    });
  }

  Future<List<TrackingSession>> getTrackingSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tracking_sessions');
    return List.generate(maps.length, (i) => TrackingSession(
      startTime: DateTime.fromMillisecondsSinceEpoch(maps[i]['start_time']),
      endTime: maps[i]['end_time'] != null ? DateTime.fromMillisecondsSinceEpoch(maps[i]['end_time']) : null,
      distance: maps[i]['distance'],
      maxSpeed: maps[i]['max_speed'],
      waitingTime: Duration(seconds: maps[i]['waiting_time']),
    ));
  }

  Future<void> insertLocation(LocationModel location) async {
    final db = await database;
    await db.insert('locations', location.toMap());
  }

  Future<List<LocationModel>> getLocations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('locations');
    return List.generate(maps.length, (i) => LocationModel.fromMap(maps[i]));
  }

  Future<void> saveTrackingState(Tracking state) async {
    final db = await database;
    await db.insert('tracking_state', {
      'current_latitude': state.currentLocation.latitude,
      'current_longitude': state.currentLocation.longitude,
      'last_latitude': state.lastLocation?.latitude,
      'last_longitude': state.lastLocation?.longitude,
      'distance': state.distance,
      'is_waiting': state.isWaiting ? 1 : 0,
      'waiting_time': state.waitingTime.inSeconds,
      'is_connected': state.isConnected ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Tracking?> getLastTrackingState() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tracking_state');
    if (maps.isNotEmpty) {
      final map = maps.first;
      return Tracking(
        currentLocation: Location(
          latitude: map['current_latitude'],
          longitude: map['current_longitude'],
          speed: 0, timestamp: DateTime.now(), // You might want to store and retrieve this as well
        ),
        lastLocation: map['last_latitude'] != null ? Location(
          latitude: map['last_latitude'],
          longitude: map['last_longitude'],
          speed: 0, timestamp: DateTime.now(),
        ) : null,
        distance: map['distance'],
        isWaiting: map['is_waiting'] == 1,
        waitingTime: Duration(seconds: map['waiting_time']),
        isConnected: map['is_connected'] == 1,
      );
    }
    return null;
  }

  Future<void> clearTrackingState() async {
    final db = await database;
    await db.delete('tracking_state');
  }
}