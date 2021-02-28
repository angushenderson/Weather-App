import 'package:client/models/rain_graph.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class PrecipitationCard extends StatelessWidget {
  final List<RainGraphModel> precipitation;

  PrecipitationCard(this.precipitation);

  @override
  Widget build(BuildContext context) {
    // Determine maximum rainfall
    List<RainGraphModel> p = [...precipitation];
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
              child: Container(
                height: 100,
                child: PrecipitationLineChart(precipitation, maxPrecipitation),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Chart stuff
class PrecipitationLineChart extends StatefulWidget {
  final List<RainGraphModel> precipitation;
  final double maxPrecipitation;

  PrecipitationLineChart(this.precipitation, this.maxPrecipitation);

  @override
  _PrecipitationLineChartState createState() =>
      _PrecipitationLineChartState(this.precipitation, maxPrecipitation);
}

class _PrecipitationLineChartState extends State<PrecipitationLineChart> {
  List<RainGraphModel> precipitation;
  double maxPrecipitation;

  _PrecipitationLineChartState(this.precipitation, this.maxPrecipitation);

  List<Color> gradientColors = [
    const Color.fromARGB(255, 40, 216, 164),
    const Color.fromARGB(255, 61, 168, 255),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
          child: LineChart(
            mainData(),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    List<FlSpot> spots = [];
    precipitation.asMap().forEach((index, item) {
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
                return DateFormat('HH:mm').format(precipitation[0].dt);
              case 10:
                return DateFormat('HH:mm').format(precipitation[30].dt);
              case 20:
                return DateFormat('HH:mm').format(precipitation[60].dt);
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
                  strokeWidth: 2,
                  strokeColor: Colors.black,
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
