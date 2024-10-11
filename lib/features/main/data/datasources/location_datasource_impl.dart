// import 'dart:async';
//
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
// import 'package:injectable/injectable.dart';
// import 'package:location/location.dart';
// import '../../domain/entities/location.dart' as loc;
// import 'location_datasource.dart';
//
// @LazySingleton(as: LocationDataSource)
// class LocationDataSourceImpl implements LocationDataSource {
//   final _locationController = StreamController<loc.Location>.broadcast();
//
//   @override
//   Future<bool> requestPermission() async {
//     final status = await bg.BackgroundGeolocation.requestPermission();
//     return status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS;
//   }
//
//   @override
//   Stream<loc.Location> getLocationStream() {
//     return _locationController.stream;
//   }
//
//   @override
//   Future<void> startBackgroundTracking() async {
//     await bg.BackgroundGeolocation.ready(bg.Config(
//         desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
//         distanceFilter: 10.0,
//         stopOnTerminate: false,
//         startOnBoot: true,
//         debug: true,
//         logLevel: bg.Config.LOG_LEVEL_VERBOSE
//     ));
//
//     bg.BackgroundGeolocation.onLocation((bg.Location location) {
//       _locationController.add(loc.Location(
//         latitude: location.coords.latitude,
//         longitude: location.coords.longitude,
//         speed: location.coords.speed ?? 0,
//         timestamp: DateTime.fromMillisecondsSinceEpoch(int.parse(location.timestamp)),
//       ));
//     });
//
//     await bg.BackgroundGeolocation.start();
//   }
//
//   @override
//   Future<void> stopBackgroundTracking() async {
//     await bg.BackgroundGeolocation.stop();
//   }
// }