import 'package:client/models/forecast.dart';
import 'package:client/models/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchCityNameFromServer(
    double lat, double lon) async {
  final response = await http.get(
      'http://192.168.1.104:5000/city/${lat.toString()}/${lon.toString()}');
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    if (json['locations'] != Null) {
      return json['locations'][0];
    } else {
      return {};
    }
  } else {
    throw Exception(
        'Failed to fetch data from API. HTTP response code ${response.statusCode}');
  }
}
