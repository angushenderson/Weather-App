import 'package:client/models/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Locations> getAllLocations() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> locationNames = [];
  List<String> locationLats = [];
  List<String> locationLons = [];
  List<String> locationCountries = [];
  int currentLocationIndex = 0;

  // Get location names
  try {
    locationNames = prefs.getStringList('locationNames');
  } catch (e) {
    locationNames = [];
    prefs.setStringList('locationNames', []);
  }

  // Get lat coords of locations
  try {
    locationLats = prefs.getStringList('locationsLats');
  } catch (e) {
    locationLats = [];
    prefs.setStringList('locationsLats', []);
  }

  // Get lon coords of locations
  try {
    locationLons = prefs.getStringList('locationLons');
  } catch (e) {
    locationLons = [];
    prefs.setStringList('locationLons', []);
  }

  // Get country of locations
  try {
    locationCountries = prefs.getStringList('locationCountries');
  } catch (e) {
    locationCountries = [];
    prefs.setStringList('locationCountries', []);
  }

  // Get index of current location
  try {
    currentLocationIndex = prefs.getInt('currentLocationIndex');
  } catch (e) {
    currentLocationIndex = 0;
    prefs.setInt('currentLocationIndex', 0);
  }

  Locations locations =
      Locations(locations: [], currentLocationIndex: currentLocationIndex);
  for (int i = 0; i < locationNames.length; i++) {
    locations.locations.add(Location(
      name: locationNames[i],
      lat: double.parse(locationLats[i]),
      lon: double.parse(locationLons[i]),
      country: locationCountries[i],
    ));
  }
  return locations;
}

void addLocation(Location location, {appendToExistingValues = true}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Locations locations = Locations(locations: []);
  // Get existing locations
  if (appendToExistingValues) {
    locations = await getAllLocations();
  }
  // Add new location
  locations.locations.add(location);
  print(locations.locations.length);
  List<String> locationNames = [];
  List<String> locationLats = [];
  List<String> locationLons = [];
  List<String> locationCountries = [];

  // Format for rewrite
  for (int i = 0; i < locations.locations.length; i++) {
    locationNames.add(locations.locations[i].name);
    locationLats.add(locations.locations[i].lat.toString());
    locationLons.add(locations.locations[i].lon.toString());
    locationCountries.add(locations.locations[i].country);
  }

  print(locationNames);
  prefs.setStringList('locationNames', locationNames);
  prefs.setStringList('locationsLats', locationLats);
  prefs.setStringList('locationLons', locationLons);
  prefs.setStringList('locationCountries', locationCountries);
}
