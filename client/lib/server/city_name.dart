import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>> fetchCityNameFromServer(
    double lat, double lon) async {
  String url = "";
  if (env['SERVER_PORT'] != '') {
    url = "${env['PROTOCOL']}://${env['SERVER_ADDRESS']}:${env['SERVER_PORT']}/city/${lat.toString()}/${lon.toString()}";
  } else {
    url = "${env['PROTOCOL']}://${env['SERVER_ADDRESS']}/city/${lat.toString()}/${lon.toString()}";
  }
  final response = await http.get(url);
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
