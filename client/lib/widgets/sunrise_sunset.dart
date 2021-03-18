import 'package:client/models/forecast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:path_drawing/path_drawing.dart';

class SunriseSunset extends StatefulWidget {
  final Forecast forecast;

  SunriseSunset(this.forecast);

  @override
  _SunriseSunsetState createState() => _SunriseSunsetState(forecast);
}

class _SunriseSunsetState extends State<SunriseSunset> {
  final Forecast forecast;

  _SunriseSunsetState(this.forecast);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 28.0,
            horizontal: 32.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    DateFormat('HH:mm').format(forecast.sunrise),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                  ),
                  Container(height: 8),
                  Text(
                    'Sunrise',
                    style: Theme.of(context).textTheme.headline6.copyWith(),
                  ),
                ],
              ),
              Image(
                width: 42.0,
                height: 42.0,
                image: AssetImage(
                  'lib/assets/images/01.png',
                ),
              ),
              Column(
                children: [
                  Text(
                    DateFormat('HH:mm').format(forecast.sunset),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                  ),
                  Container(height: 8),
                  Text(
                    'Sunset',
                    style: Theme.of(context).textTheme.headline6.copyWith(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  final DateTime sunrise;
  final DateTime sunset;

  OpenPainter(this.sunrise, this.sunset);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color.fromARGB(255, 101, 101, 101)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    var startPoint = Offset(0, size.height);
    var controlPoint1 = Offset(size.width / 4, size.height / 16);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 16);
    var endPoint = Offset(size.width, size.height);

    // Draw dashed arc using painter
    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(
        dashPath(
          path,
          dashArray: CircularIntervalList<double>(<double>[3, 2]),
        ),
        paint);

    int totalTime = sunset.difference(sunrise).inMinutes;
    int passedTime = DateTime.now().difference(sunrise).inMinutes;
    if (passedTime < 0) {
      passedTime = 0;
    } else if (passedTime > totalTime) {
      passedTime = totalTime;
    }

    final icon = Icons.add;
    var builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      fontFamily: icon.fontFamily,
    ))
      ..addText(String.fromCharCode(icon.codePoint));
    var para = builder.build();
    para.layout(const ui.ParagraphConstraints(width: 60));
    canvas.drawParagraph(para, const Offset(60, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
