import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is Tracking) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Stop Tracking'),
                        content: const Text('Are you sure you want to stop tracking? This will reset all data.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Stop'),
                            onPressed: () {
                              context.read<LocationBloc>().add(StopTracking());
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.stop),
                label: const Text(AppConstants.stopTracking),
                style: ElevatedButton.styleFrom(),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<LocationBloc>().add(ToggleWaitingMode());
                },
                icon: Icon(state.isWaiting ? Icons.play_arrow : Icons.pause),
                label: Text(state.isWaiting ? 'Resume' : AppConstants.waitingMode),
                style: ElevatedButton.styleFrom(

                ),
              ),
            ],
          );
        } else {
          return Center(
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<LocationBloc>().add(StartTracking());
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text(AppConstants.startTracking),
              style: ElevatedButton.styleFrom(),
            ),
          );
        }
      },
    );
  }
}