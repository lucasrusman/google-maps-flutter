part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMaker;
  final List<Feature> places;
  final List<Feature> history;

  const SearchState({
    this.displayManualMaker = false,
    this.places = const [],
    this.history = const [],
  });

  SearchState copyWith(
          {bool? displayManualMaker,
          List<Feature>? places,
          List<Feature>? history}) =>
      SearchState(
        displayManualMaker: displayManualMaker ?? this.displayManualMaker,
        places: places ?? this.places,
        history: history ?? this.history,
      );
  @override
  List<Object> get props => [displayManualMaker, places, history];
}
