// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:google_maps_app/blocs/blocs.dart';

class GpsAccesScreen extends StatelessWidget {
  const GpsAccesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return (!state.isGpsEnable)
              ? const _EnableGpsMessage()
              : const _AccessButton();
        },
      )),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Es necesario el acceso a gps',
          style: TextStyle(fontSize: 24),
        ),
        MaterialButton(
          onPressed: () {
            final gpsBloc = context.read<GpsBloc>();
            gpsBloc.askGpsAccess();
          },
          color: Colors.black,
          shape: const StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent,
          child: const Text(
            'Solicitar acceso',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        )
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Debe habilitar el GPS',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
    );
  }
}
