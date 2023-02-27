// To parse this JSON data, do
//
//     final placesResponse = placesResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class PlacesResponse {
  PlacesResponse({
    required this.type,
    // required this.query,
    required this.features,
    required this.attribution,
  });

  final String type;
  // final List<String> query;
  final List<Feature> features;
  final String attribution;

  factory PlacesResponse.fromRawJson(String str) =>
      PlacesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlacesResponse.fromJson(Map<String, dynamic> json) => PlacesResponse(
        type: json["type"],
        // query: List<String>.from(json["query"].map((x) => x)),
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        // "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
      };
}

class Feature {
  Feature({
    required this.id,
    required this.type,
    required this.placeType,
    required this.properties,
    required this.textEs,
    required this.placeNameEs,
    required this.text,
    required this.placeName,
    required this.center,
    required this.geometry,
    // required this.context,
  });

  final String id;
  final String type;
  final List<String> placeType;
  final Properties properties;
  final String textEs;
  final String placeNameEs;
  final String text;
  final String placeName;
  final List<double> center;
  final Geometry geometry;
  // final List<Context> context;

  factory Feature.fromRawJson(String str) => Feature.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        properties: Properties.fromJson(json["properties"]),
        textEs: json["text_es"],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x?.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        // context:
            // List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "properties": properties.toJson(),
        "text_es": textEs,
        "place_name_es": placeNameEs,
        "text": text,
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        // "context": List<dynamic>.from(context.map((x) => x.toJson())),
      };
}

class Context {
  Context({
    required this.id,
    required this.textEs,
    required this.text,
    // required this.languageEs,
    required this.language,
    required this.shortCode,
    this.wikidata,
  });

  final String id;
  final String textEs;
  final String text;
  // final Language languageEs;
  final String? language;
  final ShortCode? shortCode;
  final String? wikidata;

  factory Context.fromRawJson(String str) => Context.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        textEs: json["text_es"],
        text: json["text"],
        wikidata: json["wikidata"],
        // languageEs: languageValues.map[json["language_es"]]!,
        language: json["language"],
        shortCode: shortCodeValues.map[json["short_code"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text_es": textEs,
        "text": text,
        "wikidata": wikidata,
        // "language_es": languageValues.reverse[languageEs],
        "language": language,
        "short_code": shortCodeValues.reverse[shortCode],
      };
}

enum ShortCode { AR_B, AR, AR_C }

final shortCodeValues = EnumValues(
    {"ar": ShortCode.AR, "AR-B": ShortCode.AR_B, "AR-C": ShortCode.AR_C});

class Geometry {
  Geometry({
    required this.coordinates,
    required this.type,
  });

  final List<double> coordinates;
  final String type;

  factory Geometry.fromRawJson(String str) =>
      Geometry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
      };
}

class Properties {
  Properties({
    this.foursquare,
    this.landmark,
    this.address,
    this.category,
    this.maki,
  });

  final String? foursquare;
  final bool? landmark;
  final String? address;
  final String? category;
  final String? maki;

  factory Properties.fromRawJson(String str) =>
      Properties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        // foursquare: json["foursquare"],
        landmark: json["landmark"],
        address: json["address"],
        category: json["category"],
        maki: json["maki"],
      );

  Map<String, dynamic> toJson() => {
        // "foursquare": foursquare,
        "landmark": landmark,
        "address": address,
        "category": category,
        "maki": maki,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
