import 'package:client/models/forecast.dart';
import 'package:client/models/rain_graph.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class PrecipitationCard extends StatelessWidget {
  final List<RainGraphModel> hourPrecipitation;
  final Forecast forecast;

  PrecipitationCard(this.hourPrecipitation, this.forecast);

  @override
  Widget build(BuildContext context) {
    return PrecipitationLineChart(hourPrecipitation, forecast);
  }
}

// Chart stuff
class PrecipitationLineChart extends StatefulWidget {
  final List<RainGraphModel> precipitation;
  final Forecast forecast;

  PrecipitationLineChart(this.precipitation, this.forecast);

  @override
  _PrecipitationLineChartState createState() =>
      _PrecipitationLineChartState(this.precipitation, this.forecast);
}

class _PrecipitationLineChartState extends State<PrecipitationLineChart>
    with AutomaticKeepAliveClientMixin {
  List<RainGraphModel> hourPrecipitation;
  Forecast forecast;
  double maxPrecipitation;
  int dataShowing = 0;

  _PrecipitationLineChartState(this.hourPrecipitation, this.forecast);

  List<Color> gradientColors = [
    const Color.fromARGB(255, 40, 216, 164),
    const Color.fromARGB(255, 61, 168, 255),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Determine maximum rainfall
    List<RainGraphModel> p = [...hourPrecipitation];
    p.sort((a, b) => a.precipitation.compareTo(b.precipitation));
    double maxPrecipitation = p.last.precipitation;
    maxPrecipitation = maxPrecipitation + (maxPrecipitation * 0.25);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 32.0, right: 32.0, top: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Precipitation\nTrend',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.help_outline_rounded),
                  // ),
                  FlatButton(
                    color: gradientColors[1],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text(
                      ['1 Hour', '2 Days', '5 Days'][dataShowing],
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    onPressed: () {
                      int newData = dataShowing + 1;
                      if (newData > 2) {
                        newData = 0;
                      }

                      setState(() {
                        dataShowing = newData;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
              child: Container(
                height: 100,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                      ),
                      child: LineChart(
                        [
                          hourData(),
                          twoDayData(),
                          weekData(),
                        ][dataShowing],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData hourData() {
    List<FlSpot> spots = [];
    hourPrecipitation.asMap().forEach((index, item) {
      spots.add(FlSpot(index / 3, item.precipitation));
    });
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 0,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.w500,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return DateFormat('HH:mm')
                    .format(hourPrecipitation[0].dt.add(Duration(
                          seconds: hourPrecipitation[0].timezoneOffset,
                        )));
              case 10:
                return DateFormat('HH:mm')
                    .format(hourPrecipitation[30].dt.add(Duration(
                          seconds: hourPrecipitation[30].timezoneOffset,
                        )));
              case 20:
                return DateFormat('HH:mm')
                    .format(hourPrecipitation[60].dt.add(Duration(
                          seconds: hourPrecipitation[60].timezoneOffset,
                        )));
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          reservedSize: 0,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        // border: Border.all(color: const Color(0xff37434d), width: 1),
        border: const Border(
          left: BorderSide(color: Color(0xff37434d), width: 1),
          bottom: BorderSide(color: Color(0xff37434d), width: 1),
          right: BorderSide(color: Color(0xff37434d), width: 1),
        ),
      ),
      minX: 0,
      maxX: 20,
      minY: 0,
      maxY: maxPrecipitation,
      lineTouchData: LineTouchData(
        enabled: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: lerpGradient(
                    barData.colors, barData.colorStops, 100 / 61 * index / 100),
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 8,
                  color: lerpGradient(
                      barData.colors, barData.colorStops, percent / 100),
                  strokeWidth: 3,
                  strokeColor: Colors.white,
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Color.fromARGB(255, 61, 168, 255).withOpacity(0.3),
          tooltipRoundedRadius: 16,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((lineBarSpot) {
              return LineTooltipItem(
                lineBarSpot.y.toString() + 'mm',
                const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData twoDayData() {
    List<FlSpot> spots = [];
    forecast.twoDayPrecipitation.asMap().forEach((index, item) {
      if (index < 41) {
        spots.add(FlSpot(index / 2, item.precipitation));
      }
    });

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 0,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.w500,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return DateFormat('HH:mm')
                    .format(forecast.twoDayPrecipitation[0].dt);
              case 10:
                return DateFormat('HH:mm')
                    .format(forecast.twoDayPrecipitation[20].dt);
              case 20:
                return DateFormat('EE')
                    .format(forecast.twoDayPrecipitation[39].dt);
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          reservedSize: 0,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        // border: Border.all(color: const Color(0xff37434d), width: 1),
        border: Border.symmetric(
          vertical: BorderSide(color: Color(0xff37434d), width: 1),
        ),
      ),
      minX: 0,
      maxX: 20,
      minY: 0,
      maxY: maxPrecipitation,
      lineTouchData: LineTouchData(
        enabled: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: lerpGradient(
                    barData.colors, barData.colorStops, 100 / 61 * index / 100),
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 8,
                  color: lerpGradient(
                      barData.colors, barData.colorStops, percent / 100),
                  strokeWidth: 3,
                  strokeColor: Colors.white,
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Color.fromARGB(255, 61, 168, 255).withOpacity(0.3),
          tooltipRoundedRadius: 16,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((lineBarSpot) {
              return LineTooltipItem(
                DateFormat('ha').format(forecast
                        .twoDayPrecipitation[(lineBarSpot.x * 2).toInt()].dt) +
                    ' ' +
                    lineBarSpot.y.toString() +
                    'mm',
                const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData weekData() {
    List<FlSpot> spots = [];
    forecast.fiveDayForecast.asMap().forEach((index, item) {
      spots.add(FlSpot(index / 2, item.precipitation));
    });
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 0,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.w500,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'Today';
              case 10:
                return DateFormat('EE').format(forecast
                    .fiveDayForecast[forecast.fiveDayForecast.length ~/ 2].dt);
              case 20:
                return DateFormat('EE')
                    .format(forecast.fiveDayForecast.last.dt);
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          reservedSize: 0,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        // border: Border.all(color: const Color(0xff37434d), width: 1),
        border: Border.symmetric(
          vertical: BorderSide(color: Color(0xff37434d), width: 1),
        ),
      ),
      minX: 0,
      maxX: 20,
      minY: 0,
      maxY: maxPrecipitation,
      lineTouchData: LineTouchData(
        enabled: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: lerpGradient(
                    barData.colors, barData.colorStops, 100 / 61 * index / 100),
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 8,
                  color: lerpGradient(
                      barData.colors, barData.colorStops, percent / 100),
                  strokeWidth: 3,
                  strokeColor: Colors.white,
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Color.fromARGB(255, 61, 168, 255).withOpacity(0.3),
          tooltipRoundedRadius: 16,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((lineBarSpot) {
              return LineTooltipItem(
                DateFormat('EE ha').format(forecast
                        .fiveDayForecast[(lineBarSpot.x * 2).toInt()].dt) +
                    ' ' +
                    lineBarSpot.y.toString() +
                    'mm',
                const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (stops == null || stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / colors.length;
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s], rightStop = stops[s + 1];
    final leftColor = colors[s], rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT);
    }
  }
  return colors.last;
}
