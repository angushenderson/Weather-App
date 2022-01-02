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
  int pressure; // Current air pressure
  double uvi; // Current UVI
  double windSpeed; // Current wind speed
  int visibility; // Current visibility
  int timezoneOffset; // Timezone offset of forecast location

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
    this.pressure,
    this.uvi,
    this.windSpeed,
    this.visibility,
    this.timezoneOffset,
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
          timezoneOffset: json['timezone_offset'],
        ));
      }
    });

    List<RainGraphModel> precipitation = [];
    json['forecast']['rain_hour'].asMap().forEach((index, item) {
      precipitation.add(
        RainGraphModel(
          precipitation: item['precipitation'].toDouble(),
          dt: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
          timezoneOffset: json['timezone_offset'],
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
        timezoneOffset: json['timezone_offset'],
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
            timezoneOffset: json['timezone_offset'],
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
        timezoneOffset: json['timezone_offset'],
      ));
    });

    return Forecast(
      temperature: json['forecast']['current']['main']['temp'].toDouble(),
      feelsLike: json['forecast']['current']['main']['feels_like'].toDouble(),
      aqi: json['forecast']['air_pollution'][0]['main']['aqi'],
      description: description,
      icon: json['forecast']['current']['weather'][0]['icon'].substring(0, 2),
      twoDayForecast: twoDayForecast,
      dt: json['dt'],
      hourPrecipitation: precipitation,
      fiveDayForecast: fiveDayForecast,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
          json['forecast']['current']['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(
          json['forecast']['current']['sys']['sunset'] * 1000),
      weekForecast: weekForecast,
      analytics: new Analytics(
        temperature: json['analytics']['temperature'],
        precipitation: json['analytics']['precipitation'],
      ),
      twoDayPrecipitation: twoDayPrecipitation,
      pressure: json['forecast']['current']['main']['pressure'],
      uvi: json['forecast']['one_call_api']['current']['uvi'].toDouble(),
      windSpeed: json['forecast']['current']['wind']['speed'].toDouble(),
      visibility: json['forecast']['current']['visibility'],
      timezoneOffset: json['timezone_offset'],
    );
  }
}

class TwoDayForecast {
  int dt;
  double temperature;
  String icon;
  double precipitation;
  int timezoneOffset;

  TwoDayForecast({
    this.dt,
    this.temperature,
    this.icon,
    this.precipitation,
    this.timezoneOffset,
  });
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
  int timezoneOffset;

  TwoDayPrecipitation({this.dt, this.precipitation, this.timezoneOffset});
}

class Analytics {
  String temperature;
  String precipitation;

  Analytics({this.temperature, this.precipitation});
}
