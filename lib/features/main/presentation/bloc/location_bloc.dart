import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/local/database.dart';
import '../../domain/entities/tracking_session.dart';
import '../../domain/entities/location.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/start_location_tracking.dart';
import '../../domain/usecases/stop_location_tracking.dart';
import 'location_event.dart';
import 'location_state.dart';

@injectable
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;
  final StartLocationTracking startLocationTracking;
  final StopLocationTracking stopLocationTracking;
  final AppDatabase appDatabase;
  Timer? _waitingTimer;
  StreamSubscription<Location>? _locationSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  TrackingSession? _currentSession;

  LocationBloc({
    required this.getCurrentLocation,
    required this.startLocationTracking,
    required this.stopLocationTracking,
    required this.appDatabase,
  }) : super(LocationInitial()) {
    on<StartTracking>(_onStartTracking);
    on<StopTracking>(_onStopTracking);
    on<UpdateLocation>(_onUpdateLocation);
    on<ToggleWaitingMode>(_onToggleWaitingMode);
    on<UpdateConnectivityStatus>(_onUpdateConnectivityStatus);
    on<IncrementWaitingTime>(_onIncrementWaitingTime);

    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      add(UpdateConnectivityStatus(isConnected: result.last != ConnectivityResult.none,));
    });
  }

  Future<void> _onStartTracking(StartTracking event, Emitter<LocationState> emit) async {
    final permissionGranted = await _checkAndRequestPermission();
    if (!permissionGranted) {
      emit(const TrackingError('Location permission not granted'));
      return;
    }

    final locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled) {
      emit(const TrackingError('Location services are disabled'));
      return;
    }

    final success = await startLocationTracking();
    if (success) {
      _currentSession = TrackingSession(
        startTime: DateTime.now(),
        endTime: null,
        distance: 0,
        maxSpeed: 0,
        waitingTime: Duration.zero,
      );
      emit(TrackingStarted());

      _locationSubscription?.cancel();
      _locationSubscription = getCurrentLocation().listen(
            (location) => add(UpdateLocation(location)),
        onError: (error) => add(const UpdateConnectivityStatus(isConnected: false)),
      );
    } else {
      emit(const TrackingError('Failed to start tracking'));
    }
  }

  Future<void> _onStopTracking(StopTracking event, Emitter<LocationState> emit) async {
    await stopLocationTracking();
    _locationSubscription?.cancel();
    _waitingTimer?.cancel();

    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(endTime: DateTime.now());
      await appDatabase.saveTrackingSession(_currentSession!);
    }

    emit(LocationInitial());
    _currentSession = null;
  }

  void _onUpdateLocation(UpdateLocation event, Emitter<LocationState> emit) {
    if (_currentSession != null) {
      double newDistance = _currentSession!.distance;
      double newMaxSpeed = _currentSession!.maxSpeed;

      // Only update distance and max speed if not in waiting mode
      if (!_currentSession!.isWaiting) {
        newDistance += _calculateNewDistance(_currentSession!.lastLocation, event.location);
        newMaxSpeed = newMaxSpeed < event.location.speed ? event.location.speed : newMaxSpeed;
      }

      _currentSession = _currentSession!.copyWith(
        distance: newDistance,
        maxSpeed: newMaxSpeed,
        lastLocation: event.location,
      );

      emit(Tracking(
        currentLocation: event.location,
        distance: _currentSession!.distance,
        isWaiting: _currentSession!.isWaiting,
        waitingTime: _currentSession!.waitingTime,
        isConnected: true,
      ));
    }
  }

  void _onToggleWaitingMode(ToggleWaitingMode event, Emitter<LocationState> emit) {
    if (_currentSession != null) {
      final newIsWaiting = !_currentSession!.isWaiting;

      _waitingTimer?.cancel();

      if (newIsWaiting) {
        _waitingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          add(IncrementWaitingTime());
        });
      } else {
        // Update the last location when exiting waiting mode
        add(UpdateLocation(_currentSession!.lastLocation!));
      }

      _currentSession = _currentSession!.copyWith(isWaiting: newIsWaiting);
      emit((state as Tracking).copyWith(isWaiting: newIsWaiting));
    }
  }

  void _onIncrementWaitingTime(IncrementWaitingTime event, Emitter<LocationState> emit) {
    if (_currentSession != null && _currentSession!.isWaiting) {
      _currentSession = _currentSession!.copyWith(
        waitingTime: _currentSession!.waitingTime + const Duration(seconds: 1),
      );
      emit((state as Tracking).copyWith(waitingTime: _currentSession!.waitingTime));
    }
  }

  void _onUpdateConnectivityStatus(UpdateConnectivityStatus event, Emitter<LocationState> emit) {
    if (state is Tracking) {
      emit((state as Tracking).copyWith(isConnected: event.isConnected));
    }
  }

  double _calculateNewDistance(Location? lastLocation, Location newLocation) {
    if (lastLocation == null) return 0;
    return Geolocator.distanceBetween(
      lastLocation.latitude,
      lastLocation.longitude,
      newLocation.latitude,
      newLocation.longitude,
    ) / 1000;
  }

  Future<bool> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  @override
  Future<void> close() {
    _waitingTimer?.cancel();
    _locationSubscription?.cancel();
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
