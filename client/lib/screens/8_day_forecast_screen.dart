import 'dart:async';
import 'package:timeago/timeago.dart' as timeago;
import 'package:client/models/forecast.dart';
import 'package:client/models/location.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_icons/flutter_icons.dart';

class EightDayForecastScreen extends StatelessWidget {
  final Forecast forecast;
  final Location location;
  final List<Color> windSpeedColors = [
    Color.fromARGB(255, 0, 102, 204),
    Color.fromARGB(255, 51, 102, 255),
    Color.fromARGB(255, 51, 204, 255),
    Color.fromARGB(255, 0, 255, 255),
    Color.fromARGB(255, 51, 255, 204),
    Color.fromARGB(255, 0, 204, 0),
    Color.fromARGB(255, 0, 255, 0),
    Color.fromARGB(255, 255, 255, 204),
    Color.fromARGB(255, 255, 255, 0),
    Color.fromARGB(255, 255, 204, 102),
    Color.fromARGB(255, 255, 153, 0),
    Color.fromARGB(255, 255, 102, 102),
    Color.fromARGB(255, 255, 102, 255),
  ];

  EightDayForecastScreen(this.forecast, this.location);

  int windLevel(double windSpeed, {bool metric = true}) {
    // Horrific code I know, but it works
    if (metric) {
      // Conver to miles per hour
      windSpeed = windSpeed * 2.237;
    }
    // Wind speed translation into Beaufort levels
    if (windSpeed < 1) {
      return 0;
    } else if (windSpeed < 4) {
      return 1;
    } else if (windSpeed < 8) {
      return 2;
    } else if (windSpeed < 13) {
      return 3;
    } else if (windSpeed < 19) {
      return 4;
    } else if (windSpeed < 25) {
      return 5;
    } else if (windSpeed < 32) {
      return 6;
    } else if (windSpeed < 39) {
      return 7;
    } else if (windSpeed < 47) {
      return 8;
    } else if (windSpeed < 55) {
      return 9;
    } else if (windSpeed < 64) {
      return 10;
    } else if (windSpeed < 75) {
      return 11;
    } else {
      return 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
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
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: 36.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 36.0,
                    color: Theme.of(context).accentColor,
                  ),
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
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 2.0),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7),
                              child: Text(
                                location.name,
                                style: Theme.of(context).textTheme.headline1,
                              ),
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
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 18.0,
            ),
            child: Text(
              '8 Day Forecast',
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(fontSize: 26.0),
            ),
          ),

          Container(
            height: 425,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: this.forecast.weekForecast.length,
              itemBuilder: (BuildContext context, int index) {
                WeekForecastItem f = forecast.weekForecast[index];
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: index != 1
                            ? BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(55.0),
                              )
                            : BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 252, 98, 228),
                                    const Color.fromARGB(255, 43, 99, 243),
                                  ],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(1.0, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(55.0),
                              ),
                        child: SizedBox(
                          width: 110,
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, top: 28.0),
                                        child: Text(
                                          index > 1
                                              ? DateFormat('EE').format(f.dt)
                                              : index == 0
                                                  ? 'Today'
                                                  : 'Tommorow',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Text(
                                          DateFormat('d MMM').format(f.dt),
                                          style: index != 1
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                  )
                                              : Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                        ),
                                      ),
                                      Text(
                                        f.description
                                                .substring(0, 1)
                                                .toUpperCase() +
                                            f.description.substring(1),
                                        style: index != 1
                                            ? Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                )
                                            : Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Image(
                                          width: 48.0,
                                          height: 48.0,
                                          image: AssetImage(
                                            'lib/assets/images/${f.icon}.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Text(
                                      f.maxTemp.toStringAsFixed(0) + '\u00B0',
                                      style: index != 1
                                          ? Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                              )
                                          : Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      f.minTemp.toStringAsFixed(0) + '\u00B0',
                                      style: index != 1
                                          ? Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                              )
                                          : Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      bottom: 12.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: windSpeedColors[
                                            windLevel(f.windSpeed)],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0),
                                              child: Transform.rotate(
                                                angle: 2.36 +
                                                    (f.windDirection *
                                                        math.pi /
                                                        180),
                                                child: FaIcon(
                                                  FontAwesomeIcons
                                                      .locationArrow,
                                                  size: 10.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Level ${windLevel(f.windSpeed)}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 13.0,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 24.0,
                                      top: 4.0,
                                    ),
                                    child: Text(
                                      '${(f.chanceOfPrecipitation * 100).toStringAsFixed(0)}%',
                                      style: index != 1
                                          ? Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                              )
                                          : Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: (-126 * index).toDouble(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 200,
                        ),
                        child: Container(
                          width: 1008,
                          height: 100,
                          child: LineChart(
                            tempChartData(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              left: 18.0,
              right: 18.0,
              bottom: 18.0,
              top: 36.0,
            ),
            child: Text(
              'Forecast Analytics',
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(fontSize: 26.0),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(80, 251, 200, 54),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.temperatureLow,
                              color: Color.fromARGB(255, 251, 200, 54),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Temperature',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                'TEMPERATURE ANALYTICS',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      bottom: 24.0,
                      top: 0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(80, 67, 128, 244),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Icon(
                              Ionicons.ios_water,
                              color: Color.fromARGB(255, 67, 128, 244),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precipitation',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                'PRECIPITATION ANALYTICS',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 20,
          ),
        ],
      ),
    );
  }

  LineChartData tempChartData() {
    List<FlSpot> maxSpots = [];
    forecast.weekForecast.asMap().forEach((index, item) {
      maxSpots.add(FlSpot(index / 2, item.maxTemp));
    });

    List<FlSpot> minSpots = [];
    forecast.weekForecast.asMap().forEach((index, item) {
      minSpots.add(FlSpot(index / 2, item.minTemp));
    });

    // Calculate graph max and min values
    List<WeekForecastItem> p = [...forecast.weekForecast];
    p.sort((a, b) => a.maxTemp.compareTo(b.maxTemp));
    double maxTemp = p.last.maxTemp;
    p.sort((a, b) => a.minTemp.compareTo(b.minTemp));
    double minTemp = p[0].minTemp;

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      minY: minTemp,
      maxY: maxTemp,
      lineTouchData: LineTouchData(enabled: false),
      lineBarsData: [
        LineChartBarData(
          spots: maxSpots,
          show: true,
          isCurved: true,
          colors: [
            const Color.fromARGB(255, 254, 70, 100),
            const Color.fromARGB(255, 251, 225, 63),
          ],
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: false),
        ),
        LineChartBarData(
          spots: minSpots,
          show: true,
          isCurved: true,
          colors: [
            const Color.fromARGB(255, 36, 212, 156),
            const Color.fromARGB(255, 57, 160, 255),
          ],
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ],
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
