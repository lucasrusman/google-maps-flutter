// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:google_maps_app/blocs/blocs.dart';
import 'package:google_maps_app/helpers/helpers.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({super.key});

  @override
  Widget build(BuildContext context) {
    //aca se va a mostrar condicionalmente el manual marker
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMaker
            ? const _ManualMarkerBody()
            : const SizedBox();
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(children: [
        const Positioned(
          top: 70,
          left: 20,
          child: _btnBack(),
        ),
        Center(
          child: Transform.translate(
            offset: const Offset(0, -20),
            child: BounceInDown(
                from: 150,
                child: const Icon(Icons.location_on_rounded, size: 50)),
          ),
        ),
        Positioned(
          bottom: 70,
          left: 40,
          child: FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: MaterialButton(
                minWidth: size.width - 120,
                color: Colors.black,
                elevation: 0,
                height: 50,
                shape: const StadiumBorder(),
                onPressed: () async {
                  final start = locationBloc.state.lastKnowPosition;
                  if (start == null) return;
                  final end = mapBloc.mapCenter;
                  if (end == null) return;
                  showLoadingMessage(context);
                  final destination =
                      await searchBloc.getCoorsStartToEnd(start, end);
                  mapBloc.drawRoutePolyline(destination);
                  searchBloc.add(OnCloseManualMarkerEvent());
                  Navigator.pop(context);
                },
                child: const Text(
                  'Confirmar destino',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                )),
          ),
        )
      ]),
    );
  }
}

class _btnBack extends StatelessWidget {
  const _btnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
            onPressed: () {
              final searchBloc = BlocProvider.of<SearchBloc>(context);
              searchBloc.add(OnCloseManualMarkerEvent());
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
      ),
    );
  }
}
