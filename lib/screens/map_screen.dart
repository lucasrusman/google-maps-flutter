// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Project imports:
import 'package:google_maps_app/blocs/blocs.dart';
import 'package:google_maps_app/views/views.dart';
import 'package:google_maps_app/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    // locationBloc.getCurrentPosition();
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.lastKnowPosition == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return BlocBuilder<MapBloc, MapState>(
              builder: (context, mapState) {
                Map<String, Polyline> polylines = Map.from(mapState.polylines);
                if (!mapState.showMyRoute) {
                  polylines.removeWhere((key, value) => key == 'myRoute');
                }
                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      MapView(
                        initialPosition: locationState.lastKnowPosition!,
                        polylines: polylines.values.toSet(),
                        markers: mapState.markers.values.toSet(),
                      ),
                      const SearchBar(),
                      const ManualMarker()
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          BtnToggleUserRoute(),
          BtnFollowUser(),
          BtnCurrentLocation(),
        ],
      ),
    );
  }
}
