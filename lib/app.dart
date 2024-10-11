import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/main/presentation/bloc/location_bloc.dart';
import 'features/main/presentation/pages/main_page.dart';
import 'core/singleton/injection.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(
          create: (context) => getIt<LocationBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Background Location Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}