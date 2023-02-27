// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:google_maps_app/blocs/blocs.dart';
import 'package:google_maps_app/ui/ui.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final locationBloc = context.read<LocationBloc>();
    final mapBloc = context.read<MapBloc>();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: const Icon(
            Icons.my_location_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            final userLocation = locationBloc.state.lastKnowPosition;
            if (userLocation == null) {
              final snackBar = CustomSnackBar(
                message: 'No hay ubicacion',
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            }
            // //TODO: SNACKBAR
            mapBloc.moveCamera(userLocation);
          },
        ),
      ),
    );
  }
}
