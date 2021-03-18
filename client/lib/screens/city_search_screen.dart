import 'package:client/models/location.dart';
import 'package:client/server/location_search.dart';
import 'package:client/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class CitySearchScreen extends StatefulWidget {
  @override
  _CitySearchScreenState createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  var _controller = TextEditingController();
  Locations _locationSuggestions = Locations(locations: []);

  void fetchLocations(String text) async {
    if (text.length > 0) {
      try {
        var result = await fetchLocationsFromServer(text);
        setState(() {
          _locationSuggestions = result;
        });
      } catch (e) {
        print(e);
        // setState(() {
        // error = true;
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 36.0,
              ),
              child: TextField(
                autofocus: true,
                controller: _controller,
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (text) {
                  fetchLocations(text);
                },
                decoration: InputDecoration(
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  enabled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30.0),
                    ),
                  ),
                  hintText: 'Search city',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 32.0),
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        _controller.clear();
                      },
                      splashRadius: 20.0,
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).textTheme.headline6.color,
                      )),
                ),
              ),
            ),
            _locationSuggestions.locations.length > 0
                ? Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      physics: BouncingScrollPhysics(),
                      itemCount: _locationSuggestions.locations.length,
                      itemBuilder: (BuildContext context, int index) {
                        Location location =
                            _locationSuggestions.locations[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              addLocation(
                                location,
                                appendToExistingValues: true,
                              );
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: index == 0
                                  ? BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color.fromARGB(
                                              255, 252, 98, 228),
                                          const Color.fromARGB(
                                              255, 50, 99, 242),
                                        ],
                                        begin: FractionalOffset(0.0, 0.0),
                                        end: FractionalOffset(1.0, 1.0),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      ),
                                    )
                                  : BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      ),
                                    ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      location.name,
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        location.country,
                                        style: index == 0
                                            ? Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                  color: Colors.white,
                                                )
                                            : Theme.of(context)
                                                .textTheme
                                                .headline6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
