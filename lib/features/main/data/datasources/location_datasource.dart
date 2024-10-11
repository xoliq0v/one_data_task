import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

abstract class LocationDataSource {
  Future<bool> requestPermission();
  Stream<LocationData> getLocationStream();
  Future<void> startBackgroundTracking();
  Future<void> stopBackgroundTracking();
}

@LazySingleton(as: LocationDataSource)
class LocationDataSourceImpl implements LocationDataSource {
  final Location location = Location();

  @override
  Future<bool> requestPermission() async {
    final permission = await location.requestPermission();
    return permission == PermissionStatus.granted;
  }

  @override
  Stream<LocationData> getLocationStream() {
    return location.onLocationChanged;
  }

  @override
  Future<void> startBackgroundTracking() async {
    await location.enableBackgroundMode(enable: true);
  }

  @override
  Future<void> stopBackgroundTracking() async {
    await location.enableBackgroundMode(enable: false);
  }
}
