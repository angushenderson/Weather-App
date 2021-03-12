import 'package:client/models/5_day.dart';
import 'package:client/models/rain_graph.dart';

class Forecast {
  double temperature; // Current temperature
  double feelsLike; // Temperature due to current wind conditions
  int aqi; // AQI environment scores
  String description; // Description of current weather
  String icon; // Icon code for current weather condition
  List<TwoDayForecast> twoDayForecast; // Forecast for next 2 days
  int dt; // DateTime of forecast fetch from server
  List<RainGraphModel>
      hourPrecipitation; // Precipitation minute by minute for the next hour
  List<FiveDayForecastItem>
      fiveDayForecast; // Five day forecast at 3 hour intervals
  DateTime sunrise; // DateTime of current day sunrise
  DateTime sunset; // DateTime of current day sunset
  List<WeekForecastItem> weekForecast; // 8 day weekley forecast
  Analytics analytics; // Temperature analytics for 8 day weekly forecast screen
  List<TwoDayPrecipitation> twoDayPrecipitation; // 2 day rain forecast

  Forecast({
    this.temperature,
    this.feelsLike,
    this.aqi,
    this.description,
    this.icon,
    this.twoDayForecast,
    this.dt,
    this.hourPrecipitation,
    this.fiveDayForecast,
    this.sunrise,
    this.sunset,
    this.weekForecast,
    this.analytics,
    this.twoDayPrecipitation,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    String description =
        json['forecast']['current']['weather'][0]['description'];
    description = description[0].toUpperCase() + description.substring(1);

    List<TwoDayForecast> twoDayForecast = [];
    int day = 0;
    json['forecast']['2_day_hourly'].forEach((item) {
      if (DateTime.fromMicrosecondsSinceEpoch(item['dt'] * 1000000).hour == 0) {
        day++;
      }
      if (day < 2) {
        twoDayForecast.add(TwoDayForecast(
          dt: item['dt'],
          temperature: item['temp'].toDouble(),
          icon: item['weather'][0]['icon'].substring(0, 2),
          precipitation:
              item.containsKey('rain') ? item['rain']['1h'].toDouble() : 0.0,
        ));
      }
    });

    List<RainGraphModel> precipitation = [];
    json['forecast']['rain_hour'].asMap().forEach((index, item) {
      precipitation.add(
        RainGraphModel(
          precipitation: item['precipitation'].toDouble(),
          dt: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
        ),
      );
    });

    List<FiveDayForecastItem> fiveDayForecast = [
      FiveDayForecastItem(
        temperature: json['forecast']['current']['main']['temp'].toDouble(),
        dt: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
        precipitation: json['forecast']['current'].containsKey('rain')
            ? json['forecast']['current']['rain']['1h']
            : 0,
      )
    ];
    json['forecast']['5_day_3_hour'].forEach(
      (item) {
        fiveDayForecast.add(
          FiveDayForecastItem(
            temperature: item['main']['temp'].toDouble(),
            dt: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
            precipitation:
                item.containsKey('rain') ? item['rain']['3h'].toDouble() : 0.0,
          ),
        );
      },
    );

    List<WeekForecastItem> weekForecast = [];
    json['forecast']['week'].forEach((item) {
      weekForecast.add(
        WeekForecastItem(
          dt: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
          description: item['weather'][0]['description'],
          icon: item['weather'][0]['icon'].substring(0, 2),
          maxTemp: item['temp']['max'].toDouble(),
          minTemp: item['temp']['min'].toDouble(),
          windDirection: item['wind_deg'],
          windSpeed: item['wind_speed'].toDouble(),
          chanceOfPrecipitation: item['pop'].toDouble(),
        ),
      );
    });

    List<TwoDayPrecipitation> twoDayPrecipitation = [];
    json['forecast']['2_day_hourly'].forEach((item) {
      twoDayPrecipitation.add(TwoDayPrecipitation(
        dt: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
        precipitation:
            item.containsKey('rain') ? item['rain']['1h'].toDouble() : 0.0,
      ));
    });

    return Forecast(
      temperature: json['forecast']['current']['main']['temp'].toDouble(),
      feelsLike: json['forecast']['current']['main']['feels_like'].toDouble(),
      aqi: json['forecast']['air_pollution']['aqi'],
      description: description,
      icon: json['forecast']['current']['weather'][0]['icon'].substring(0, 2),
      twoDayForecast: twoDayForecast,
      dt: json['dt'],
      hourPrecipitation: precipitation,
      fiveDayForecast: fiveDayForecast,
      sunrise: json['forecast']['current']['sunrise'],
      sunset: json['forecast']['current']['sunset'],
      weekForecast: weekForecast,
      analytics: new Analytics(
        // temperature: json['analytics']['temperature'],
        precipitation: json['analytics']['precipitation'],
      ),
      twoDayPrecipitation: twoDayPrecipitation,
    );
  }
}

class TwoDayForecast {
  int dt;
  double temperature;
  String icon;
  double precipitation;

  TwoDayForecast({this.dt, this.temperature, this.icon, this.precipitation});
}

class WeekForecastItem {
  DateTime dt;
  String description;
  String icon;
  double maxTemp;
  double minTemp;
  int windDirection;
  double windSpeed;
  double chanceOfPrecipitation;

  WeekForecastItem({
    this.dt,
    this.description,
    this.icon,
    this.maxTemp,
    this.minTemp,
    this.windDirection,
    this.windSpeed,
    this.chanceOfPrecipitation,
  });
}

class TwoDayPrecipitation {
  DateTime dt;
  double precipitation;

  TwoDayPrecipitation({this.dt, this.precipitation});
}

class Analytics {
  String temperature;
  String precipitation;

  Analytics({this.temperature, this.precipitation});
}
