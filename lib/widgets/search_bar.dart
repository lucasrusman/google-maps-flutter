// Flutter imports:
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:google_maps_app/blocs/blocs.dart';
import 'package:google_maps_app/delegates/delegates.dart';
import 'package:google_maps_app/models/models.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMaker
            ? const SizedBox()
            : Transform.translate(
                offset: const Offset(0, -20),
                child: BounceInDown(from: 250, child: const _SearchBarBody()));
      },
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({super.key});
  void onSearchResult(BuildContext context, SearchResult result) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    if (result.manual == true) {
      searchBloc.add(OnActivateManualMarkerEvent());
      return;
    }
    if (result.position != null) {
      final start = locationBloc.state.lastKnowPosition!;
      final end = result.position!;
      final destination = await searchBloc.getCoorsStartToEnd(start, end);
      await mapBloc.drawRoutePolyline(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        height: 50,
        child: GestureDetector(
          onTap: () async {
            final result = await showSearch(
                context: context, delegate: SearchDestinationDelegate());
            if (result == null) return;
            onSearchResult(context, result);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
            child: const Text('A donde quieres ir?'),
          ),
        ),
      ),
    );
  }
}
