import 'package:client/models/forecast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ForecastInfoCard extends StatelessWidget {
  final Forecast forecast;

  ForecastInfoCard(this.forecast);

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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.eco_outlined,
                        color: Colors.white,
                        size: 36.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          forecast.aqi.toStringAsFixed(0),
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                              ),
                        ),
                      ),
                      Text(
                        'Air quality',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Entypo.gauge,
                        color: Colors.white,
                        size: 36.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          forecast.pressure.toStringAsFixed(0) + 'hpa',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                              ),
                        ),
                      ),
                      Text(
                        'Pressure',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        Icon(
                          Ionicons.ios_sunny,
                          color: Colors.white,
                          size: 36.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            forecast.uvi.toString() == '0.0'
                                ? '0'
                                : forecast.uvi.toString(),
                            style:
                                Theme.of(context).textTheme.headline2.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.0,
                                    ),
                          ),
                        ),
                        Text(
                          'UV',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(
                        Ionicons.ios_water,
                        color: Colors.white,
                        size: 36.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          forecast.hourPrecipitation[0].precipitation
                                      .toString() ==
                                  '0.0'
                              ? '0mm'
                              : forecast.hourPrecipitation[0].precipitation
                                      .toString() +
                                  'mm',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                              ),
                        ),
                      ),
                      Text(
                        'Precipitation',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Feather.wind,
                        color: Colors.white,
                        size: 36.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          forecast.windSpeed.toString() == '0.0'
                              ? '0km/h'
                              : forecast.windSpeed.toString() + 'km/h',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                              ),
                        ),
                      ),
                      Text(
                        'Wind speed',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Ionicons.md_eye,
                        color: Colors.white,
                        size: 36.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          (forecast.visibility / 1000).toStringAsFixed(1) +
                              'km',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                              ),
                        ),
                      ),
                      Text(
                        'Visibility',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
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
