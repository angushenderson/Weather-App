import 'package:client/models/location.dart';
import 'package:client/screens/8_day_forecast_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:client/models/forecast.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class DailyTemperatureScroller extends StatefulWidget {
  final List<TwoDayForecast> forecast;
  final Forecast fullForecast;
  final Location location;

  DailyTemperatureScroller(this.forecast, this.fullForecast, this.location);

  @override
  _DailyTemperatureScrollerState createState() =>
      _DailyTemperatureScrollerState(
          this.forecast, this.fullForecast, this.location);
}

class _DailyTemperatureScrollerState extends State<DailyTemperatureScroller> {
  final List<TwoDayForecast> forecast;
  int _activeDay = 0;
  AutoScrollController controller;
  final Forecast fullForecast;
  final Location location;

  _DailyTemperatureScrollerState(
      this.forecast, this.fullForecast, this.location);

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
      axis: Axis.horizontal,
      viewportBoundaryGetter: () => Rect.fromLTRB(
          0,
          0,
          MediaQuery.of(context).padding.right,
          MediaQuery.of(context).padding.bottom),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        _activeDay = 0;
                        _scrollToIndex(0);
                      })
                    },
                    child: Column(
                      children: [
                        AnimatedDefaultTextStyle(
                          style: _activeDay == 0
                              ? Theme.of(context).textTheme.headline2.copyWith(
                                    color: Colors.white,
                                  )
                              : Theme.of(context).textTheme.headline2.copyWith(
                                    color: Color.fromARGB(255, 101, 101, 101),
                                  ),
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            'Today',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AnimatedContainer(
                            width: 6.0,
                            height: 6.0,
                            duration: const Duration(milliseconds: 500),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _activeDay == 0
                                  ? Colors.white
                                  : Color.fromRGBO(0, 0, 0, 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        _activeDay = 1;
                        _scrollToIndex(24 -
                            DateTime.fromMillisecondsSinceEpoch(
                                    forecast[0].dt * 1000)
                                .hour);
                      })
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        children: [
                          AnimatedDefaultTextStyle(
                            style: _activeDay == 1
                                ? Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                      color: Colors.white,
                                    )
                                : Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                      color: Color.fromARGB(255, 101, 101, 101),
                                    ),
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              'Tommorow',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: AnimatedContainer(
                              width: 6.0,
                              height: 6.0,
                              duration: const Duration(milliseconds: 500),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _activeDay == 1
                                    ? Colors.white
                                    : Color.fromRGBO(0, 0, 0, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EightDayForecastScreen(fullForecast, location),
                      ),
                    )
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        'Next 8 days',
                        style: TextStyle(
                          color: Color.fromARGB(255, 50, 99, 242),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 165,
          clipBehavior: Clip.none,
          child: NotificationListener(
            onNotification: (t) {
              double pos = controller.position.pixels / 100;
              if (pos >
                      (23 -
                          DateTime.fromMillisecondsSinceEpoch(
                                  forecast[0].dt * 1000)
                              .hour) &&
                  _activeDay == 0) {
                setState(() {
                  _activeDay = 1;
                });
              } else if (pos <=
                      (23 -
                          DateTime.fromMillisecondsSinceEpoch(
                                  forecast[0].dt * 1000)
                              .hour) &&
                  _activeDay == 1) {
                setState(() {
                  _activeDay = 0;
                });
              }
              // print('Position: ${pos}');
              // print(controller.position.pixels);
              return false;
            },
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 25),
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              controller: controller,
              itemCount: this.forecast.length,
              itemBuilder: (BuildContext context, int index) {
                TwoDayForecast f = forecast[index];
                DateTime dt =
                    DateTime.fromMicrosecondsSinceEpoch(f.dt * 1000000);
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: controller,
                  index: index,
                  child: GestureDetector(
                    child: Container(
                      clipBehavior: Clip.none,
                      height: 140,
                      width: 80,
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: index == 1
                          ? BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 252, 98, 228),
                                  const Color.fromARGB(255, 50, 99, 242),
                                ],
                                begin: FractionalOffset(0.0, 0.0),
                                end: FractionalOffset(1.0, 1.0),
                              ),
                              // backgroundBlendMode: ,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(32, 50, 99, 242),
                                  blurRadius: 10.0,
                                  spreadRadius: 4.0,
                                  offset: Offset(0, 20),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(40.0),
                            )
                          : BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              dt.hour.toString().length == 1
                                  ? '0' + dt.hour.toString() + ':00'
                                  : dt.hour.toString() + ':00',
                              style: TextStyle(
                                color: index != 1
                                    ? Color.fromARGB(255, 101, 101, 101)
                                    : Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              child: Image(
                                width: 42.0,
                                image: AssetImage(
                                  'lib/assets/images/${f.icon}.png',
                                ),
                              ),
                            ),
                            Text(
                              f.temperature.toStringAsFixed(0) == '-0'
                                  ? '0\u00B0'
                                  : f.temperature.toStringAsFixed(0) + '\u00B0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
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
          ),
        ),
      ],
    );
  }

  Future _scrollToIndex(index) async {
    await controller.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin,
        duration: Duration(milliseconds: 500));
  }
}
