import 'package:client/models/forecast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Forecast> fetchForecastFromServer(double lat, double lon) async {
  final response = await http.get(
      'http://192.168.1.104:5000/forecast/${lat.toString()}/${lon.toString()}');
  if (response.statusCode == 200) {
    return Forecast.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Failed to fetch data from API. HTTP response code ${response.statusCode}');
  }
}
