import operator


class ForecastAnalytics:
    TEMPERATURE_NOTIFY_PERCENTAGE = 0.75

    def __init__(self, forecast) -> None:
        """
        :param forecast: Forecast object
        :type forecast: open_weather.Forecast
        """
        self.forecast = forecast

    def weekly_temperature(self) -> str:
        """
        Generate informative analytics statement regarding temperature trends
        :return str: Analytics message
        """
        current_temp = self.forecast.daily_forecast_7_days[0]['temp']['day']
        max_index, max_temp = max(
            enumerate(map(lambda item: item['temp']['max'], self.forecast.daily_forecast_7_days)), key=operator.itemgetter(1))
        min_index, min_temp = min(
            enumerate(map(lambda item: item['temp']['min'], self.forecast.daily_forecast_7_days)), key=operator.itemgetter(1))
        average_temp = round(sum(list(map(
            lambda item: item['temp']['day'], self.forecast.daily_forecast_7_days))) / len(self.forecast.daily_forecast_7_days), 1)
        # average_temp = round(sum(map(lambda item: item['temp']['day'], self.forecast.daily_forecast_7_days)) / len(
        # self.forecast.daily_forecast_7_days), 2)

        # Select most appropriate metric

        temperature_buffer = max_temp - min_temp

        # I want to know when it will start cooling down, or when it will start warming up
        for day in self.forecast.daily_forecast_7_days:
            if day['temp']['day'] > max_temp * self.TEMPERATURE_NOTIFY_PERCENTAGE:
                pass
        else:
            # Pretty stable temperature - return average weekly temperature
            pass

        return f'Average temperature of {average_temp}°'

    def weekly_precipitation(self) -> str:
        """
        Generate informative analytics statement regarding precipitation trends
        :return str: Analytics message
        """
        # Get precipitation volumes from forecast object
        precipitation_volumes = list(map(
            lambda day: day['rain'] if 'rain' in day else 0, self.forecast.daily_forecast_7_days))
        # precipitation_probability = list(map())
        if precipitation_volumes[0] == 0:
            # Currently no rain
            next_rain = next((index for index, value in enumerate(
                precipitation_volumes) if value), None)
            # Create nicely formatted string - when will it next rain
            if next_rain:
                return f"Expect rain {'in ' + str(next_rain) + (' days' if next_rain != 1 else ' day') if next_rain > 1 else ' tomorrow'}"
            else:
                # No rain all week
                return 'No rain is expected this week!'
        else:
            # Currently raining
            next_no_rain = next((index for index, value in enumerate(
                precipitation_volumes) if not value), None)
            if next_no_rain:
                # Raining for x number of days
                return f"Expect rain for {next_no_rain} more day{'s' if next_no_rain != 1 else ''}"
            else:
                # Rain all week
                return 'Rain is expected all week :('
