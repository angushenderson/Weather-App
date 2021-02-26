import 'dart:convert';
import 'package:client/models/location.dart';
import 'package:http/http.dart' as http;

Future<Locations> fetchLocationsFromServer(String location) async {
  final response =
      await http.get('http://192.168.1.104:5000/search-suggestions/$location');
  if (response.statusCode == 200) {
    return Locations.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Failed to fetch data from API. HTTP response code ${response.statusCode}');
  }
}
