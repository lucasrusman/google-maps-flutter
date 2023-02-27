// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:google_maps_app/models/models.dart';
import 'package:google_maps_app/services/services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;
  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>((event, emit) => emit(state.copyWith(
          displayManualMaker: true,
        )));
    on<OnCloseManualMarkerEvent>((event, emit) => emit(state.copyWith(
          displayManualMaker: false,
        )));
    on<OnNewPlacesFoundEvent>((event, emit) => emit(state.copyWith(
          places: event.places,
        )));
    on<OnAddToHistoryEvent>((event, emit) =>
        emit(state.copyWith(history: [event.place, ...state.history])));
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final res = await trafficService.getCoorsStartToEnd(start, end);
    //informacion del destino
    final endPlace = await trafficService.getInformationByCoors(end);
    final distance = res.routes[0].distance;
    final duration = res.routes[0].duration;
    final geometry = res.routes[0].geometry;
    // decodificar el geometry
    final points = decodePolyline(geometry, accuracyExponent: 6);
    final latLngList = points
        .map((coordinates) =>
            LatLng(coordinates[0].toDouble(), coordinates[1].toDouble()))
        .toList();
    return RouteDestination(
      points: latLngList,
      duration: duration,
      distance: distance,
      endPlace : endPlace
    );
  }

  Future getPlacesByQuery(LatLng proximity, String query) async {
    final newPlaces = await trafficService.getResultsByQuery(proximity, query);
    add(OnNewPlacesFoundEvent(newPlaces));
  }
}
