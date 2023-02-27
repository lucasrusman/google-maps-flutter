// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Project imports:
import 'package:google_maps_app/blocs/blocs.dart';

class MapView extends StatelessWidget {
  final LatLng initialPosition;
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  const MapView({
    super.key,
    required this.initialPosition,
    required this.polylines,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    final mapBloc = context.read<MapBloc>();
    final size = MediaQuery.of(context).size;
    final CameraPosition initialCameraPosition =
        CameraPosition(target: initialPosition, zoom: 15);
    return SizedBox(
        width: size.width,
        height: size.height,
        child: Listener(
          onPointerMove: (event) => mapBloc.add(OnStopFollowingUserMapEvent()),
          child: GoogleMap(
            mapToolbarEnabled: false,
            initialCameraPosition: initialCameraPosition,
            compassEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            polylines: polylines,
            markers: markers,
            onMapCreated: (controller) =>
                mapBloc.add(OnMapInitializedEvent(controller)),
            onCameraMove: (position) => mapBloc.mapCenter = position.target,
          ),
        ));
  }
}
