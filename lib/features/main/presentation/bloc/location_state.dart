import 'package:equatable/equatable.dart';

import '../../domain/entities/location.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class TrackingStarted extends LocationState {}

class Tracking extends LocationState {
  final Location currentLocation;
  final Location? lastLocation;
  final double distance;
  final bool isWaiting;
  final Duration waitingTime;
  final bool isConnected;

  const Tracking({
    required this.currentLocation,
    this.lastLocation,
    required this.distance,
    required this.isWaiting,
    required this.waitingTime,
    required this.isConnected
  });

  Tracking copyWith({
    Location? currentLocation,
    Location? lastLocation,
    double? distance,
    bool? isWaiting,
    Duration? waitingTime,
    bool? isConnected
  }) {
    return Tracking(
      currentLocation: currentLocation ?? this.currentLocation,
      lastLocation: lastLocation ?? this.lastLocation,
      distance: distance ?? this.distance,
      isWaiting: isWaiting ?? this.isWaiting,
      waitingTime: waitingTime ?? this.waitingTime,
      isConnected: isConnected ?? this.isConnected
    );
  }

  @override
  List<Object?> get props => [currentLocation, lastLocation, distance, isWaiting, waitingTime,isConnected];
}

class TrackingStopped extends LocationState {}

class TrackingError extends LocationState {
  final String message;

  const TrackingError(this.message);

  @override
  List<Object> get props => [message];
}

