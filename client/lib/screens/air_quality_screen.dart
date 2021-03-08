import 'package:client/models/forecast.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AirQualityScreen extends StatefulWidget {
  final Forecast forecast;

  AirQualityScreen({this.forecast});

  @override
  _AirQualityScreenState createState() => _AirQualityScreenState(this.forecast);
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  Forecast forecast;

  _AirQualityScreenState(this.forecast);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            child: Stack(
              children: [
                Container(
                  // child: Text(
                  //   forecast.aqi.toString(),
                  //   style: TextStyle(
                  //     fontSize: 196,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 500,
                        showLabels: false,
                        showTicks: false,
                        axisLineStyle: AxisLineStyle(
                          thickness: 0.1,
                          thicknessUnit: GaugeSizeUnit.factor,
                          gradient: const SweepGradient(
                            colors: <Color>[
                              Color.fromARGB(255, 35, 255, 223),
                              Color.fromARGB(255, 249, 240, 53),
                              Color.fromARGB(255, 255, 59, 53),
                              Color.fromARGB(255, 255, 0, 25),
                              Color.fromARGB(255, 153, 0, 204),
                              Color.fromARGB(255, 77, 0, 38),
                            ],
                            stops: <double>[
                              0.1,
                              0.2,
                              0.5,
                              0.7,
                              0.85,
                              1.0,
                            ],
                          ),
                          // cornerStyle: CornerStyle.bothCurve,
                        ),
                        // pointers: <GaugePointer>[
                        //   RangePointer(
                        //     value: 300,

                        //   ),
                        // ],
                        ranges: <GaugeRange>[
                          GaugeRange(
                            startValue: forecast.aqi.toDouble(),
                            endValue: 500,
                            color: Theme.of(context).cardColor,
                            sizeUnit: GaugeSizeUnit.factor,
                            startWidth: 0.11,
                            endWidth: 0.11,
                            rangeOffset: -0.001,
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            // widget: Column(
                            //   children: [
                            //     Text(
                            //       'AQI',
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .headline6
                            //           .copyWith(
                            //             fontSize: 24,
                            //             fontWeight: FontWeight.w400,
                            //           ),
                            //     ),
                            //     Text(
                            //       forecast.aqi.toString(),
                            //       style: TextStyle(
                            //         fontSize: 96,
                            //         fontWeight: FontWeight.w600,
                            //         letterSpacing: 1.2,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            widget: Text(
                              forecast.aqi.toString(),
                              style: TextStyle(
                                fontSize: 96,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                            ),
                            angle: 270,
                            positionFactor: 0.1,
                          ),
                        ],
                        // ranges: <GaugeRange>[
                        //   GaugeRange(
                        //     color: Theme.of(context).cardColor,
                        //     startValue: 300,
                        //     endValue: 500,
                        //   ),
                        // ],
                        // pointers: <GaugePointer>[
                        //   RangePointer(
                        //     value: 100,
                        //     width: 0.1,
                        //     sizeUnit: GaugeSizeUnit.factor,
                        //     cornerStyle: CornerStyle.bothCurve,
                        //     enableAnimation: true,
                        //   ),
                        // ],
                      ),
                      // RadialAxis(),
                      // ranges: <GaugeRange>[
                      //   GaugeRange(
                      //     startValue: 0,
                      //     endValue: 50,
                      //     color: Colors.green,
                      //   ),
                      //   GaugeRange(
                      //     startValue: 50,
                      //     endValue: 100,
                      //     color: Colors.yellow,
                      //   ),
                      //   GaugeRange(
                      //     startValue: 100,
                      //     endValue: 150,
                      //     color: Colors.orange,
                      //   ),
                      //   GaugeRange(
                      //     startValue: 150,
                      //     endValue: 200,
                      //     color: Colors.red,
                      //   ),
                      //   GaugeRange(
                      //     startValue: 200,
                      //     endValue: 300,
                      //     color: Colors.purple,
                      //   ),
                      //   GaugeRange(
                      //     startValue: 300,
                      //     endValue: 500,
                      //     color: Colors.brown,
                      //   ),
                      // ],
                      // pointers: <GaugePointer>[NeedlePointer(value: 90)],
                      // annotations: <GaugeAnnotation>[
                      //   GaugeAnnotation(
                      //       widget: Container(
                      //           child: Text('90.0',
                      //               style: TextStyle(
                      //                   fontSize: 25,
                      //                   fontWeight: FontWeight.bold))),
                      //       angle: 90,
                      //       positionFactor: 0.5),
                      // ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
