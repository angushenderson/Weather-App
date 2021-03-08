import 'package:client/models/forecast.dart';
import 'package:flutter/material.dart';

class ForecastInfoCard extends StatelessWidget {
  Forecast forecast;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: [
          Row(),
          Row(),
        ],
      ),
    );
  }
}
