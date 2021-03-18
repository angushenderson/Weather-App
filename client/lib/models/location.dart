import 'dart:convert';

import 'package:client/models/forecast.dart';

class Locations {
  List<Location> locations;
  int currentLocationIndex;
  int timezoneOffset;

  Locations({this.locations, this.currentLocationIndex = 0});

  factory Locations.fromJson(Map<String, dynamic> json) {
    List<Location> locations = [];
    for (int i = 0; i < json['locations'].length; i++) {
      locations.add(Location(
        name: json['locations'][i]['name'],
        country: json['locations'][i]['country'],
        lat: json['locations'][i]['lat'].toDouble(),
        lon: json['locations'][i]['lon'].toDouble(),
      ));
    }
    return Locations(locations: locations);
  }
}

class Location {
  String name;
  String country;
  double lat;
  double lon;
  bool isCurrentLocation = false;
  Forecast forecast;
  int timezoneOffset;

  Location({
    this.name,
    this.country,
    this.lat,
    this.lon,
    this.forecast,
    this.timezoneOffset,
  });
}
