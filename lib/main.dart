// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:google_maps_app/blocs/blocs.dart';
import 'package:google_maps_app/screens/screens.dart';
import 'package:google_maps_app/services/services.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => GpsBloc(),
    ),
    BlocProvider(
      create: (context) => LocationBloc(),
    ),
    BlocProvider(
      create: (context) => MapBloc(locationBloc: context.read<LocationBloc>()),
    ),
    BlocProvider(
      create: (context) => SearchBloc(trafficService: TrafficService()),
    ),
  ], child: const MapsApp()));
}

class MapsApp extends StatelessWidget {
  const MapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: LoadingScreen());
  }
}
