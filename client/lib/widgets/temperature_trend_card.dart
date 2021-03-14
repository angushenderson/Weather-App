import 'package:client/models/5_day.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class TemperatureCard extends StatelessWidget {
  final List<FiveDayForecastItem> temperatureForecast;

  TemperatureCard(this.temperatureForecast);

  @override
  Widget build(BuildContext context) {
    // Determine maximum temperature
    List<FiveDayForecastItem> p = [...temperatureForecast];
    p.sort((a, b) => a.temperature.compareTo(b.temperature));
    double maxTemp = p.last.temperature;
    maxTemp = maxTemp + (maxTemp * 0.25);
    double minTemp = p[0].temperature;
    minTemp = minTemp - (minTemp * 0.15);

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
                    'Temperature\nTrend',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.help_outline_rounded),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
              child: Container(
                height: 100,
                child:
                    TemperatureLineChart(temperatureForecast, maxTemp, minTemp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Chart stuff
class TemperatureLineChart extends StatefulWidget {
  final List<FiveDayForecastItem> temperature;
  final double maxTemp;
  final double minTemp;

  TemperatureLineChart(this.temperature, this.maxTemp, this.minTemp);

  @override
  _PrecipitationLineChartState createState() => _PrecipitationLineChartState(
      this.temperature, this.maxTemp, this.minTemp);
}

class _PrecipitationLineChartState extends State<TemperatureLineChart> {
  List<FiveDayForecastItem> temperature;
  double maxTemp;
  double minTemp;

  _PrecipitationLineChartState(this.temperature, this.maxTemp, this.minTemp);

  List<Color> gradientColors = [
    const Color.fromARGB(255, 255, 125, 61),
    const Color.fromARGB(255, 255, 53, 53),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        LineChart(
          mainData(),
        ),
      ],
    );
  }

  LineChartData mainData() {
    List<FlSpot> spots = [];
    temperature.asMap().forEach((index, item) {
      spots.add(FlSpot(index / 2, item.temperature));
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
            fontSize: 14,
          ),
          getTitles: (value) {
            if (value.toInt() == 0) {
              return DateFormat('ha').format(temperature[0].dt);
            } else if (value.toInt() == 10) {
              return DateFormat('dd/MM')
                  .format(temperature[temperature.length ~/ 2].dt);
            } else if (value.toInt() == 20) {
              return DateFormat('dd/MM').format(temperature.last.dt);
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 0,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          getTitles: (value) {
            return '';
          },
          margin: 8,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(color: Color(0xff37434d), width: 1),
          bottom: BorderSide(color: Color(0xff37434d), width: 1),
          right: BorderSide(color: Color(0xff37434d), width: 1),
        ),
      ),
      minX: 0,
      maxX: 20,
      minY: minTemp,
      maxY: maxTemp,
      lineTouchData: LineTouchData(
        enabled: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: lerpGradient(
                    barData.colors, barData.colorStops, 100 / 40 * index / 100),
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
          tooltipBgColor: Color.fromARGB(255, 255, 53, 53).withOpacity(0.3),
          tooltipRoundedRadius: 16,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((lineBarSpot) {
              DateTime displayDate =
                  temperature[(lineBarSpot.x * 2).round()].dt;
              String d =
                  "${DateFormat('hha').format(displayDate).substring(0, 1) != '0' ? DateFormat('hha').format(displayDate) : DateFormat('hha').format(displayDate).substring(1)} ${displayDate.day}/${displayDate.month}: ";

              return LineTooltipItem(
                lineBarSpot.y.toStringAsFixed(0) != '-0'
                    ? d + lineBarSpot.y.toStringAsFixed(0) + '\u00B0'
                    : d + '0\u00B0',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          show: true,
          isCurved: true,
          colors: gradientColors,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
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
