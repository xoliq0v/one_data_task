import 'package:injectable/injectable.dart';

import '../repositories/location_repositroy.dart';

@injectable
class StopLocationTracking {
  final LocationRepository repository;

  StopLocationTracking(this.repository);

  Future<void> call() async {
    await repository.stopBackgroundTracking();
  }
}
