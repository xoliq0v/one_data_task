import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_data_task/features/main/presentation/pages/sessions_list_page.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_state.dart';
import '../widgets/control_button.dart';
import '../widgets/location_display.dart';
import '../widgets/error_display.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SessionListPage()));
            },
          ),
        ],
      ),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is TrackingError)
                ErrorDisplay(message: state.message)
              else if (state is Tracking && !state.isConnected)
                const ErrorDisplay(message: 'No internet connection')
              else
                const LocationDisplay(),
              const SizedBox(height: 20),
              const ControlButtons(),
            ],
          );
        },
      ),
    );
  }
}