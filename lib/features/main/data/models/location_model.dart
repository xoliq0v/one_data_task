import 'package:location/location.dart';

import '../../domain/entities/location.dart' as l;

class LocationModel extends l.Location {
  LocationModel({
    required double latitude,
    required double longitude,
    required double speed,
    required DateTime timestamp,
  }) : super(
    latitude: latitude,
    longitude: longitude,
    speed: speed,
    timestamp: timestamp,
  );

  factory LocationModel.fromLocationData(LocationData data) {
    return LocationModel(
      latitude: data.latitude ?? 0,
      longitude: data.longitude ?? 0,
      speed: data.speed ?? 0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(data.time?.toInt() ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude'],
      longitude: map['longitude'],
      speed: map['speed'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }
}