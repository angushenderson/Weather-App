import 'package:client/models/location.dart';
import 'package:client/screens/city_search_screen.dart';
import 'package:client/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  void reorderData(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      if (oldIndex == locations.currentLocationIndex) {
        updateCurrentLocationIndex(newIndex);
        locations.currentLocationIndex = newIndex;
      } else if (newIndex <= locations.currentLocationIndex) {
        updateCurrentLocationIndex(locations.currentLocationIndex + 1);
        locations.currentLocationIndex += 1;
      }

      final location = locations.locations.removeAt(oldIndex);
      locations.locations.insert(newIndex, location);

      updateAllLocations(locations);
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
              child: ReorderableListView(
                onReorder: reorderData,
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                header: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 78, bottom: 32),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7),
                        child: Text(
                          'Locations',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                  ],
                ),
                children: new List<Widget>.generate(
                  locations.locations.length,
                  (index) {
                    Location location = locations.locations[index];
                    return Container(
                      key: Key(index.toString()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.all(16.0),
                          decoration: index == locations.currentLocationIndex
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6),
                                      child: Text(
                                        location.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        index == locations.currentLocationIndex
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0, right: 4.0),
                                                child: Icon(
                                                  Icons.my_location_rounded,
                                                  color: index ==
                                                          locations
                                                              .currentLocationIndex
                                                      ? Colors.white
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .color,
                                                  size: 12.0,
                                                ),
                                              )
                                            : Container(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            location.country,
                                            style: index ==
                                                    locations
                                                        .currentLocationIndex
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
                                  ],
                                ),
                                index != locations.currentLocationIndex
                                    ? Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: Text(
                                                    'Delete permenantly?',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline2,
                                                  ),
                                                  content: Text(
                                                    'Are you sure you want to remove ${location.name} permenantly?',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .cardColor,
                                                  actions: [
                                                    FlatButton(
                                                      child: Text('No'),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                    FlatButton(
                                                      child: Text('Yes!'),
                                                      onPressed: () {
                                                        setState(() {
                                                          locations.locations
                                                              .removeAt(index);
                                                          updateAllLocations(
                                                              locations);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                barrierDismissible: true,
                                              );
                                            },
                                            child: Container(
                                              height: 48,
                                              width: 48,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    const Color.fromARGB(
                                                        255, 252, 98, 228),
                                                    const Color.fromARGB(
                                                        255, 50, 99, 242),
                                                  ],
                                                  begin: FractionalOffset(
                                                      0.0, 0.0),
                                                  end: FractionalOffset(
                                                      1.0, 1.0),
                                                ),
                                              ),
                                              child: Icon(
                                                FontAwesomeIcons.trash,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
