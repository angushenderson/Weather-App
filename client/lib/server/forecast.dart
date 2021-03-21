import 'package:client/models/forecast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Forecast> fetchForecastFromServer(double lat, double lon) async {
  final response = await http.get(
      "${env['PROTOCOL']}://${env['SERVER_ADDRESS']}:${env['SERVER_PORT']}/forecast/${lat.toString()}/${lon.toString()}");
  if (response.statusCode == 200) {
    return Forecast.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Failed to fetch data from API. HTTP response code ${response.statusCode}');
  }
}
