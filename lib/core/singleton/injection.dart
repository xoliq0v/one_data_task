import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/main/data/datasources/location_datasource.dart';
import '../../features/main/data/local/database.dart';
import '../../features/main/data/repositories/location_repository_impl.dart';
import '../../features/main/domain/repositories/location_repositroy.dart';
import '../../features/main/domain/usecases/get_current_location.dart';
import '../../features/main/domain/usecases/start_location_tracking.dart';
import '../../features/main/domain/usecases/stop_location_tracking.dart';
import '../../features/main/domain/usecases/update_user_settings.dart';
import '../../features/main/presentation/bloc/location_bloc.dart';
final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> init() async {
  // Database
  getIt.registerLazySingleton(() => AppDatabase.instance);

  // Data sources
  getIt.registerLazySingleton<LocationDataSource>(() => LocationDataSourceImpl());

  // Repositories
  getIt.registerLazySingleton<LocationRepository>(
        () => LocationRepositoryImpl(getIt<LocationDataSource>(), getIt<AppDatabase>()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetCurrentLocation(getIt<LocationRepository>()));
  getIt.registerLazySingleton(() => StartLocationTracking(getIt<LocationRepository>()));
  getIt.registerLazySingleton(() => StopLocationTracking(getIt<LocationRepository>()));
  getIt.registerLazySingleton(() => UpdateUserSettings(getIt<LocationRepository>()));

  // BLoCs
  getIt.registerFactory(
        () => LocationBloc(
      getCurrentLocation: getIt<GetCurrentLocation>(),
      startLocationTracking: getIt<StartLocationTracking>(),
      stopLocationTracking: getIt<StopLocationTracking>(),
          appDatabase: getIt<AppDatabase>(),
    ),
  );
}
