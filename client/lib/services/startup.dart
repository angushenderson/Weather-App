import 'package:client/models/location.dart';
import 'package:client/server/city_name.dart';
import 'package:client/services/current_location.dart';
import 'package:client/services/shared_preferences.dart';

Future<Locations> loadLocations() async {
  // Fetch current location
  double lat;
  double lon;

  // First determine the current location to provide info on
  print('Determining position');
  var position = await determinePosition();
  lat = position.latitude;
  lon = position.longitude;

  // Get all stored locations
  print('Fetching all locations');
  var locations = await getAllLocations();
  print('Fetched locations');
  print(locations.locations.length);
  locations.locations.forEach((location) {
    print(location.name);
  });
  print(locations.currentLocationIndex);
  locations.locations[locations.currentLocationIndex].lat = lat;
  locations.locations[locations.currentLocationIndex].lon = lon;

  // Get current location name from API request
  print('Determening city name');
  Map<String, dynamic> city = await fetchCityNameFromServer(lat, lon);
  if (city != {}) {
    locations.locations[locations.currentLocationIndex].name = city['name'];
    locations.locations[locations.currentLocationIndex].country =
        city['country'];
    print(city);
  } else {
    locations.locations[locations.currentLocationIndex].name =
        'Current location';
    locations.locations[locations.currentLocationIndex].country = '';
  }

  return locations;

  // determinePosition().then((location) {
  //   lat = location.latitude;
  //   lon = location.longitude;
  //   // Load stored locations

  //   getAllLocations().then((locations) async {
  //     locations.locations.forEach((location) {
  //       print(location);
  //     });
  //     locations.locations[locations.currentLocationIndex].lat = lat;
  //     locations.locations[locations.currentLocationIndex].lon = lon;
  //     // Fetch city name
  //     Map<String, dynamic> city = await fetchCityNameFromServer(lat, lon);
  //     locations.locations[locations.currentLocationIndex].name = city['name'];
  //     locations.locations[locations.currentLocationIndex].country =
  //         city['country'];
  //     print('RETURNING');
  //     return locations;
  //   }).catchError((error) {
  //     print('Error getting stored locations: ' + error);
  //   });
  // }).catchError((error) {
  //   print('Error determening position: ' + error);
  // });
}
