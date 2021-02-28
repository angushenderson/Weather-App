import 'dart:async';
import 'package:client/models/forecast.dart';
import 'package:client/models/location.dart';
import 'package:client/screens/air_quality_screen.dart';
import 'package:client/screens/city_select_screen.dart';
import 'package:client/services/startup.dart';
import 'package:client/widgets/daily_temperature_scroller.dart';
import 'package:client/widgets/precipitation_card.dart';
import 'package:client/widgets/temperature_trend_card.dart';
import 'package:flutter/material.dart';
import 'package:client/server/forecast.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Locations _locations;
  bool error = false;
  final controller = PageController();
  TabController _tabController;

  void fetchLocations() async {
    try {
      var result = await loadLocations();
      setState(() {
        _locations = result;
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    }
  }

  void fetchForecast(int locationIndex) async {
    try {
      var result = await fetchForecastFromServer(
          _locations.locations[locationIndex].lat,
          _locations.locations[locationIndex].lon);
      setState(() {
        _locations.locations[locationIndex].forecast = result;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = true;
      });
    }
  }

  void fetchAllForecasts() async {
    try {
      for (int i = 0; i < _locations.locations.length; i++) {
        var location = _locations.locations[i];
        var result = await fetchForecastFromServer(location.lat, location.lon);
        location.forecast = result;
      }

      setState(() {
        _locations = _locations;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = true;
      });
    }
  }

  Future<void> _refreshForecast() async {
    return fetchForecast(_tabController.index);
  }

  void startup() async {
    fetchLocations();
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabContent = [];
    if (_locations != null) {
      _locations.locations.asMap().forEach((index, location) {
        if (index == _locations.currentLocationIndex) {
          location.isCurrentLocation = true;
        }
        tabContent.add(HomeScreenContent(location));
      });
    }

    return DefaultTabController(
      length: _locations != null ? _locations.locations.length : 0,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: _locations != null
            ? TabBarView(
                controller: _tabController,
                children: tabContent,
                // children: [
                // RefreshIndicator(
                //   backgroundColor: Theme.of(context).cardColor,
                //   onRefresh: _refreshForecast,
                //   child: HomeScreenContent(_forecast),
                // ),
                // RefreshIndicator(
                //   backgroundColor: Theme.of(context).cardColor,
                //   onRefresh: _refreshForecast,
                //   child: HomeScreenContent(_forecast),
                // ),
                // ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Container(height: 8.0),
                    Text(
                      'Fetching locations...',
                      style: Theme.of(context).textTheme.headline2,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  final Location location;

  HomeScreenContent(this.location);

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState(location);
}

class _HomeScreenContentState extends State<HomeScreenContent>
    with AutomaticKeepAliveClientMixin<HomeScreenContent> {
  // final Forecast _forecast;

  final Location location;
  Forecast forecast;
  bool error = false;

  _HomeScreenContentState(this.location);

  @override
  bool get wantKeepAlive => true;

  void fetchForecast() async {
    try {
      var result = await fetchForecastFromServer(location.lat, location.lon);
      setState(() {
        forecast = result;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = true;
      });
    }
  }

  Future<void> _refreshForecast() async {
    return fetchForecast();
  }

  @override
  void initState() {
    super.initState();
    fetchForecast();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return forecast != null
        ? RefreshIndicator(
            backgroundColor: Theme.of(context).cardColor,
            onRefresh: _refreshForecast,
            child: ListView(
              physics:
                  AlwaysScrollableScrollPhysics(), // BouncingScrollPhysics(),
              children: [
                // Header Code
                Container(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.menu_rounded,
                          size: 36.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CitySelectScreen(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.location_city_rounded,
                              size: 36.0,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_vert,
                              size: 36.0,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 2.0),
                                  child: Text(
                                    location.name,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 3.0,
                                  ),
                                  child: Row(
                                    children: [
                                      location.isCurrentLocation
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0),
                                              child: Icon(
                                                Icons.my_location_rounded,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .color,
                                                size: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .fontSize,
                                              ),
                                            )
                                          : Container(),
                                      UpdateTime(forecast.dt),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AirQualityScreen(
                                      forecast: forecast,
                                    ),
                                  ),
                                )
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 4.0, 0),
                                      child: Icon(
                                        Icons.eco_outlined,
                                        size: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        forecast.aqi.toString().padLeft(
                                            4 - forecast.aqi.toString().length,
                                            ' '),
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Large temperature square
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(64),
                            child: Container(
                              clipBehavior: Clip.none,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 252, 98, 228),
                                    const Color.fromARGB(255, 50, 99, 242),
                                  ],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(1.0, 1.0),
                                ),
                                // borderRadius: BorderRadius.circular(64.0),
                              ),
                              child: Center(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Text(
                                      forecast.temperature.toStringAsFixed(0),
                                      style: TextStyle(
                                        fontSize: 172.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Positioned(
                                      right: -42,
                                      child: Text(
                                        '\u00B0',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 128.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 42.0,
                          child: Text(
                            forecast.description,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 72.0,
                          child: Text(
                            forecast.feelsLike.toStringAsFixed(0) !=
                                    forecast.temperature.toStringAsFixed(0)
                                ? '(Feels like ' +
                                    forecast.feelsLike.toStringAsFixed(0) +
                                    '\u00B0)'
                                : '',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -80,
                          child: Image(
                            image: AssetImage(
                                'lib/assets/images/${forecast.icon}.png'),
                            width: 180,
                            height: 180,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 52,
                ),
                // Info widgets
                DailyTemperatureScroller(forecast.twoDayForecast),
                TemperatureCard(forecast.fiveDayForecast),
                PrecipitationCard(forecast.hourPrecipitation),
              ],
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Container(height: 8.0),
                Text(
                  'Fetching forecast...',
                  style: Theme.of(context).textTheme.headline2,
                )
              ],
            ),
          );
  }
}

class UpdateTime extends StatefulWidget {
  final int dt; // Fetched time

  UpdateTime(this.dt);

  @override
  _UpdateTimeState createState() => _UpdateTimeState(this.dt);
}

class _UpdateTimeState extends State<UpdateTime> {
  Timer timer;
  int dt;

  _UpdateTimeState(this.dt);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String displayTime(DateTime fetchedTime, DateTime currentTime) {
    return timeago.format(
        new DateTime.now().subtract(currentTime.difference(fetchedTime)));
  }

  @override
  Widget build(BuildContext context) {
    DateTime fetchedTime = DateTime.fromMicrosecondsSinceEpoch(dt * 1000000);
    DateTime currentTime = DateTime.now();

    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Text(
        'Updated ' + displayTime(fetchedTime, currentTime),
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
