// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:google_maps_app/blocs/blocs.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = context.read<MapBloc>();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                state.followUser
                    ? Icons.directions_run_rounded
                    : Icons.hail_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                mapBloc.add(OnStartFollowingUserMapEvent());
              },
            );
          },
        ),
      ),
    );
  }
}
