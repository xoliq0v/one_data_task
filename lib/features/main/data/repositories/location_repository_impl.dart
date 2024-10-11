import 'package:injectable/injectable.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repositroy.dart';
import '../datasources/location_datasource.dart';
import '../local/database.dart';
import '../models/location_model.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;
  final AppDatabase database;

  LocationRepositoryImpl(this.dataSource, this.database);

  @override
  Future<bool> requestLocationPermission() {
    return dataSource.requestPermission();
  }

  @override
  Stream<Location> getLocationStream() {
    return dataSource.getLocationStream().map((data) => LocationModel.fromLocationData(data));
  }

  @override
  Future<void> startBackgroundTracking() {
    return dataSource.startBackgroundTracking();
  }

  @override
  Future<void> stopBackgroundTracking() {
    return dataSource.stopBackgroundTracking();
  }

  @override
  Future<void> saveLocation(Location location) {
    return database.insertLocation(LocationModel(
      latitude: location.latitude,
      longitude: location.longitude,
      speed: location.speed,
      timestamp: location.timestamp,
    ));
  }

  @override
  Future<List<Location>> getLocations() async {
    final locations = await database.getLocations();
    return locations.map((model) => Location(
      latitude: model.latitude,
      longitude: model.longitude,
      speed: model.speed,
      timestamp: model.timestamp,
    )).toList();
  }
}