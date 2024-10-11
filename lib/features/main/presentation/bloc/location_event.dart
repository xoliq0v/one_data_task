import 'package:equatable/equatable.dart';

import '../../domain/entities/location.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class StartTracking extends LocationEvent {}

class StopTracking extends LocationEvent {}

class UpdateLocation extends LocationEvent {
  final Location location;

  const UpdateLocation(this.location);

  @override
  List<Object> get props => [location];
}

class ToggleWaitingMode extends LocationEvent {}

// class SaveCurrentState extends LocationEvent {}

class SaveCurrentState extends LocationEvent {}

class IncrementWaitingTime extends LocationEvent {}

class LoadSavedState extends LocationEvent {}

class UpdateConnectivityStatus extends LocationEvent {
  final bool isConnected;

  const UpdateConnectivityStatus({required this.isConnected});
}