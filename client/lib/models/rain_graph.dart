import 'package:charts_flutter/flutter.dart' as charts;

class RainGraphModel {
  double precipitation;
  int timezoneOffset;
  final DateTime dt;
  final charts.Color color;

  RainGraphModel({
    this.precipitation,
    this.dt,
    this.color,
    this.timezoneOffset,
  });
}
