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
  var locations = await getAllLocations();
  locations.locations[locations.currentLocationIndex].lat = lat;
  locations.locations[locations.currentLocationIndex].lon = lon;

  // Get current location name from API request
  print('Determening city name');
  Map<String, dynamic> city = await fetchCityNameFromServer(lat, lon);
  if (city != {}) {
    locations.locations[locations.currentLocationIndex].name = city['name'];
    locations.locations[locations.currentLocationIndex].country =
        city['country'];
  } else {
    locations.locations[locations.currentLocationIndex].name =
        'Current location';
    locations.locations[locations.currentLocationIndex].country = '';
  }

  return locations;
}
