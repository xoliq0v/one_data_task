import 'package:injectable/injectable.dart';
import '../entities/location.dart';
import '../repositories/location_repositroy.dart';

@injectable
class GetCurrentLocation {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  Stream<Location> call() {
    return repository.getLocationStream();
  }
}
