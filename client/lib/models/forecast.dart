class Forecast {
  double temperature; // Current temperature
  double feelsLike; // Temperature due to current wind conditions
  int aqi; // AQI environment scores
  String description; // Description of current weather
  String icon; // Icon code for current weather condition
  List<TwoDayForecast> twoDayForecast; // Forecast for next 2 days
  int dt; // DateTime of forecast fetch from server

  Forecast({
    this.temperature,
    this.feelsLike,
    this.aqi,
    this.description,
    this.icon,
    this.twoDayForecast,
    this.dt,
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
        ));
      }
    });

    return Forecast(
      temperature: json['forecast']['current']['main']['temp'].toDouble(),
      feelsLike: json['forecast']['current']['main']['feels_like'].toDouble(),
      aqi: json['forecast']['air_pollution'][0]['main']['aqi'],
      description: description,
      icon: json['forecast']['current']['weather'][0]['icon'].substring(0, 2),
      twoDayForecast: twoDayForecast,
      dt: json['dt'],
    );
  }
}

class TwoDayForecast {
  int dt;
  double temperature;
  String icon;

  TwoDayForecast({this.dt, this.temperature, this.icon});
}
