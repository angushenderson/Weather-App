import 'package:client/models/location.dart';
import 'package:client/screens/city_search_screen.dart';
import 'package:client/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class CitySelectScreen extends StatefulWidget {
  @override
  _CitySelectScreenState createState() => _CitySelectScreenState();
}

class _CitySelectScreenState extends State<CitySelectScreen> {
  Locations locations = Locations(locations: []);

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  _loadLocations() async {
    // Load shared preferences
    locations = await getAllLocations();
    print(locations.locations);
    setState(() {
      locations = locations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CitySearchScreen(),
              ),
            );
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 252, 98, 228),
                  const Color.fromARGB(255, 50, 99, 242),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 1.0),
              ),
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  physics: BouncingScrollPhysics(),
                  itemCount: locations.locations.length,
                  itemBuilder: (BuildContext context, int index) {
                    Location location = locations.locations[index];
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: index == 0
                          ? BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 252, 98, 228),
                                  const Color.fromARGB(255, 50, 99, 242),
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
                              style: Theme.of(context).textTheme.headline2,
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
                                    : Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
