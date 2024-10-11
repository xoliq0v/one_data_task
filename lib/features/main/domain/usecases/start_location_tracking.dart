import 'package:injectable/injectable.dart';

import '../repositories/location_repositroy.dart';

@injectable
class StartLocationTracking {
  final LocationRepository repository;

  StartLocationTracking(this.repository);

  Future<bool> call() async {
    final hasPermission = await repository.requestLocationPermission();
    if (hasPermission) {
      await repository.startBackgroundTracking();
      return true;
    }
    return false;
  }
}