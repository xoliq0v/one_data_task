import 'package:flutter/material.dart';
import '../../data/local/database.dart';
import '../../domain/entities/tracking_session.dart';

class SessionListPage extends StatelessWidget {
  const SessionListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Sessions'),
      ),
      body: FutureBuilder<List<TrackingSession>>(
        future: AppDatabase.instance.getTrackingSessions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tracking sessions found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final session = snapshot.data![index];
                return ListTile(
                  title: Text('Session ${index + 1}'),
                  subtitle: Text(
                      'Start: ${session.startTime}\n'
                          'End: ${session.endTime ?? 'Ongoing'}\n'
                          'Distance: ${session.distance.toStringAsFixed(2)} km\n'
                          'Max Speed: ${session.maxSpeed.toStringAsFixed(2)} m/s\n'
                          'Waiting Time: ${session.waitingTime.inSeconds} seconds'
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}