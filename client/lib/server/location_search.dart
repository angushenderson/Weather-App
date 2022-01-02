import 'dart:convert';
import 'package:client/models/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Locations> fetchLocationsFromServer(String location) async {
  String url = "";
  if (env['SERVER_PORT'] != '') {
    url = "${env['PROTOCOL']}://${env['SERVER_ADDRESS']}:${env['SERVER_PORT']}/search-suggestions/$location";
  } else {
    url = "${env['PROTOCOL']}://${env['SERVER_ADDRESS']}/search-suggestions/$location";
  }
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return Locations.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Failed to fetch data from API. HTTP response code ${response.statusCode}');
  }
}
