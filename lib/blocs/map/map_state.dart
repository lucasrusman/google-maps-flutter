part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool followUser;
  final bool showMyRoute;
  //Polylines
  final Map<String, Polyline> polylines;
  //markers
  final Map<String, Marker> markers;

  const MapState({
    this.isMapInitialized = false,
    this.followUser = true,
    this.showMyRoute = true,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  })  : polylines = polylines ?? const {},
        markers = markers ?? const {};

  MapState copyWith({
    bool? isMapInitialized,
    bool? followUser,
    bool? showMyRoute,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        followUser: followUser ?? this.followUser,
        showMyRoute: showMyRoute ?? this.showMyRoute,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
      );
  @override
  List<Object> get props => [
        isMapInitialized,
        followUser,
        showMyRoute,
        polylines,
        markers,
      ];
}
