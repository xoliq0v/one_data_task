import '../entities/location.dart';

abstract class LocationRepository {
  Future<bool> requestLocationPermission();
  Stream<Location> getLocationStream();
  Future<void> startBackgroundTracking();
  Future<void> stopBackgroundTracking();
  Future<void> saveLocation(Location location);
  Future<List<Location>> getLocations();
}