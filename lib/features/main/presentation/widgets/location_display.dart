import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_state.dart';

class LocationDisplay extends StatelessWidget {
  const LocationDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is Tracking) {
          return Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Speed',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    '${state.currentLocation.speed.toStringAsFixed(2)} m/s',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Distance',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    '${state.distance.toStringAsFixed(2)} km',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Waiting Time',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    '${state.waitingTime.inSeconds} seconds',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (state.isWaiting)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Waiting Mode Active',
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          );
        }
        return const Center(child: Text('Start tracking to see location data'));
      },
    );
  }
}