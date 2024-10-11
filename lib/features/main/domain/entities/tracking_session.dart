import 'package:equatable/equatable.dart';

import 'location.dart';


class TrackingSession extends Equatable {
  final DateTime startTime;
  final DateTime? endTime;
  final double distance;
  final double maxSpeed;
  final Duration waitingTime;
  final bool isWaiting;
  final Location? lastLocation;

  const TrackingSession({
    required this.startTime,
    this.endTime,
    this.distance = 0,
    this.maxSpeed = 0,
    this.waitingTime = Duration.zero,
    this.isWaiting = false,
    this.lastLocation,
  });

  TrackingSession copyWith({
    DateTime? startTime,
    DateTime? endTime,
    double? distance,
    double? maxSpeed,
    Duration? waitingTime,
    bool? isWaiting,
    Location? lastLocation,
  }) {
    return TrackingSession(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distance: distance ?? this.distance,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      waitingTime: waitingTime ?? this.waitingTime,
      isWaiting: isWaiting ?? this.isWaiting,
      lastLocation: lastLocation ?? this.lastLocation,
    );
  }

  @override
  List<Object?> get props => [startTime, endTime, distance, maxSpeed, waitingTime, isWaiting, lastLocation];
}