// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_app/helpers/helpers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Project imports:
import 'package:google_maps_app/blocs/blocs.dart';
import 'package:google_maps_app/models/models.dart';
import 'package:google_maps_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _googleMapController;
  LatLng? mapCenter;

  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);
    //start y stop following user
    on<OnStartFollowingUserMapEvent>(_onStartFollowingUser);
    on<OnStopFollowingUserMapEvent>((event, emit) => emit(state.copyWith(
          followUser: false,
        )));
    //actualizar la polyline
    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);
    //toggle route show
    on<OnToogleUserRouteEvent>((event, emit) => emit(state.copyWith(
          showMyRoute: !state.showMyRoute,
        )));
    on<DisplayPolylinesEvent>((event, emit) => emit(state.copyWith(
          polylines: event.polylines,
          markers: event.markers,
        )));
    //listen
    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnowPosition != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }
      if (!locationState.followingUser) return;
      if (locationState.lastKnowPosition == null) return;
      moveCamera(locationState.lastKnowPosition!);
    });
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _googleMapController = event.controller;
    _googleMapController!.setMapStyle(jsonEncode(uberMapTheme));
    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUser(
    OnStartFollowingUserMapEvent event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(followUser: true));
    if (locationBloc.state.lastKnowPosition == null) return;
    moveCamera(locationBloc.state.lastKnowPosition!);
  }

  void _onPolylineNewPoint(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userLocations);

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
  }

  void moveCamera(LatLng locationCurrent) {
    final cameraUpdate = CameraUpdate.newLatLng(locationCurrent);
    _googleMapController?.animateCamera(cameraUpdate);
  }

  drawRoutePolyline(RouteDestination destination) async {
    //Polyline
    final myRoute = Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.black,
        width: 5,
        points: destination.points,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap);

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;

    // convertir de mts a kms y de horas a minutos
    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    double tripDuration = (destination.duration / 60).floorToDouble();
    //Custom Markers
    //final startIconMarer = await getAssetImageMarker();
    //final endIconMarer = await getNetworkImageMarker();
    final startIconMaker = await getStartCustomMarker(
      tripDuration.toInt(),
      destination.endPlace.text,
    );
    final endIconMaker = await getEndCustomMarker(
      kms.toInt(),
      destination.endPlace.text,
    );
    //Marker
    final startMarker = Marker(
        markerId: const MarkerId('start'),
        position: destination.points.first,
        icon: startIconMaker,
        anchor: const Offset(0.1, 1)
        // infoWindow: InfoWindow(
        //   title: 'Inicio',
        //   snippet: 'Kms: $kms, duration $tripDuration',
        // ),
        );
    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,
      icon: endIconMaker,
      // anchor: const Offset(0, 0),
      // infoWindow: InfoWindow(
      //   title: destination.endPlace.text,
      //   snippet: destination.endPlace.placeName,
      // ),
    );
    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;

    add(DisplayPolylinesEvent(currentPolylines, currentMarkers));
    // await Future.delayed(const Duration(milliseconds: 300));
    // _googleMapController?.showMarkerInfoWindow(const MarkerId('start'));
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
