import requests
import json
import os
from dotenv import load_dotenv
import time
import country_converter as coco

load_dotenv()
cc = coco.CountryConverter()


class Forecast:
    def __init__(self, location: object, units='metric') -> None:
        """
        :param location Location object: Location object of location
        :param units str: Units for API responses, acceptable units include: ['metric', 'imperial', 'standard']
        """
        self.API_KEY = os.getenv('OPEN_WEATHER_API_KEY')
        self.location = location
        self.units = units

    def __repr__(self):
        return f"<Forecast location={self.location.coords} units={self.units}>"

    @property
    def current_forecast(self) -> dict:
        """
        Returns the the current forecast with an API call.
        If current forcast already exists, the same is returned without an API call as to
        increase response times
        :return current_forecast dict: Forecast API response
        """
        self._get_json('_current_forecast',
                       f"https://api.openweathermap.org/data/2.5/weather?lat={self.location.coords[0]}&lon={self.location.coords[1]}&appid={self.API_KEY}&units={self.units}",
                       use_cache=True)
        return self._current_forecast

    @current_forecast.setter
    def current_forecast(self, val):
        """
        Prevents manually setting value
        """
        pass

    @property
    def detailed_hour_rain_forecast(self) -> dict:
        """
        Gets a minute by minute breakdown of expected rain over the next hour
        """
        self._detailed_hour_rain_forecast = self.one_call_api['minutely']
        return self._detailed_hour_rain_forecast

    @detailed_hour_rain_forecast.setter
    def detailed_hour_rain_forecast(self, val): pass

    @property
    def two_day_hourly_forecast(self):
        """
        Gets detailed forecast hour by hour over the next 2 days (48 hours), hence 48 data points.
        """
        self._two_day_hourly_forecast = self.one_call_api['hourly']
        return self._two_day_hourly_forecast

    @two_day_hourly_forecast.setter
    def two_day_hourly_forecast(self): pass

    @property
    def daily_forecast_7_days(self):
        """
        Get a detailed forcast day by day for the next week.
        """
        self._daily_forecast_7_days = self.one_call_api['daily']
        return self._daily_forecast_7_days

    @daily_forecast_7_days.setter
    def daily_forecast_7_days(self): pass

    @property
    def weather_alerts(self):
        """
        Get any current weather alerts for the current location.
        Returns None if no current weather alerts
        """
        try:
            self._weather_alerts = self.one_call_api['alerts']
            return self._weather_alerts
        except KeyError:
            return None

    @weather_alerts.setter
    def weather_alerts(self): pass

    @property
    def detailed_3_hour_5_day_forecast(self):
        """
        Detailed forecast on a 3 hour interval for the next 5 days
        """
        self._detailed_3_hour_5_day_forecast = self._get_json(
            '_detailed_3_hour_5_day_forecast', f"https://api.openweathermap.org/data/2.5/forecast?lat={self.location.coords[0]}&lon={self.location.coords[1]}&appid={self.API_KEY}&units={self.units}")
        return self._detailed_3_hour_5_day_forecast['list']

    @detailed_3_hour_5_day_forecast.setter
    def detailed_3_hour_5_day_forecast(self): pass

    @property
    def current_air_pollution(self):
        """
        Get the current air pollution reading and breakdown of gases in atmosphere in current location
        """
        self._get_json('_current_air_pollution',
                       f"http://api.openweathermap.org/data/2.5/air_pollution?lat={self.location.coords[0]}&lon={self.location.coords[1]}&appid={self.API_KEY}&units={self.units}",
                       use_cache=True)
        return self._current_air_pollution['list']

    @current_air_pollution.setter
    def current_air_pollution(self): pass

    @property
    def one_call_api(self):
        """
        Call the one_call API
        """
        self._get_json('_one_call_api',
                       f"https://api.openweathermap.org/data/2.5/onecall?lat={self.location.coords[0]}&lon={self.location.coords[1]}&appid={self.API_KEY}&units={self.units}",
                       use_cache=True)
        return self._one_call_api

    @one_call_api.setter
    def one_call_api(self): pass

    def _get_json(self, attr: str, url: str, use_cache=True) -> dict:
        """
        Response handling function, gets json response from API.
        :param attr str: Object attribute to assign response to
        :param url str: URL for API fetch
        :param use_cache bool: If False: if response already exists in object that cached data is returned instead of
                fetching fresh API data, if False fresh data is fetched each call, regardless is cache exists
        :return dict: JSON API response object
        """
        if not hasattr(self, attr) or not use_cache:
            response = self._get(url)
            setattr(self, attr, response.json())
        return getattr(self, attr)

    def _get(self, url: str) -> object:
        """
        Fetch API request and handle response codes.
        :param url str: API url to fetch
        :return response: API response, response object, ConnectionError if response code not 200
        """
        response = requests.get(url)
        if response.status_code == 200:
            return response
        else:
            raise ConnectionError(
                f"Failed to reach API: {response.status_code} status code returned.\n    URL: {url}")

    def reset_cache(self, *args: list[str]) -> None:
        """
        Delete API response cache for fresh responses
        :param *args list[str]: Params to erase
        """
        for arg in args:
            try:
                delattr(self, arg)
            except:
                pass

    @property
    def forecast(self) -> dict:
        """
        Collates all API responses into a single JSON object for sending to frontend
        Simple API entry point
        :return dict: Collated api response dictionary for serving
        """
        return {
            'dt': int(round(time.time())),
            'location': {
                'lat': self.location.coords[0],
                'lon': self.location.coords[1],
                'city': self.location.city,
            },
            'forecast': {
                'current': self.current_forecast,
                'rain_hour': self.detailed_hour_rain_forecast,
                '2_day_hourly': self.two_day_hourly_forecast,
                '5_day_3_hour': self.detailed_3_hour_5_day_forecast,
                'week': self.daily_forecast_7_days,
                'air_pollution': self.current_air_pollution,
                'weather_alerts': self.weather_alerts,
            }
        }

    @forecast.setter
    def forecast(self): pass


class Location:
    """
    Class with helper function to find location
    Before passing to Forecast class must have coordinates as an attribute
    in order to fetch location
    """

    def __init__(self, coords=(None, None), city=None):
        """
        :param coords: (Lat, lon) style coordinates to fetch forecast for
        :param city str: City name of location 
        """
        self.API_KEY = os.getenv('OPEN_WEATHER_API_KEY')
        self.SEARCH_LIMIT = 10
        self.coords = coords
        self.city = city

    def name_search(self, city_name: str, country_code='') -> dict:
        """
        Get actual locations based on search name criteria
        :param city_name: Name of city to fetch from API
        :param country_code: Optional country code to search
        :return: Search results
        """
        response = self._get(city_name, country_code=country_code)
        j = response.json()

        def pop_local_names(item):
            del item['local_names']
            return item

        # Remove local names
        # return list(map(pop_local_names, j)) if len(j) > 0 else None

        # Convert iso3166 country code to country name
        for i in range(len(j)):
            j[i]['country'] = coco.convert(
                names=j[i]['country'], to='name_short', not_found=None)
        return j

    def search_suggestions(self, search_text: str) -> list[dict]:
        """
        Get helpful location name suggestions based on what the user has already typed in
        :param search_text str: Text to search for
        :return locations list[dict]: List of locations with name, id and country code
        """
        search_text = search_text.lower()
        if len(search_text) > 0:
            # TODO Open this at server start as to improve response times
            data = json.load(open('server/API/city_list.json', 'r'))
            locations = list(
                filter(lambda item: search_text in item['name'].lower(), data[search_text[0].lower()]))
            return locations if len(locations) <= self.SEARCH_LIMIT else locations[:self.SEARCH_LIMIT]
        else:
            return ValueError('Must pass text in search_text parameter.')

    def get_city_name(self, lat, lon) -> dict:
        """
        Given lat and lon coords returns the closest city name
        :param lat str: Latitude coordinates
        :param lon str: Longitude coordinates
        :return: API response JSON Object
        """
        response = requests.get(
            f"http://api.openweathermap.org/geo/1.0/reverse?lat={lat}&lon={lon}&appid={self.API_KEY}")
        if response.status_code == 200:
            print(response.json())
            return response.json()
        else:
            raise ConnectionError(
                f"Failed to reach API: {response.status_code} status code returned.")

    def _get(self, city_name: str, country_code='') -> dict:
        """
        Send a request to the Open Weather Geocoding api
        :param city_name: City name to search
        :param country_code: Optional country code
        """
        response = requests.get(
            f"http://api.openweathermap.org/geo/1.0/direct?q={city_name},{country_code}&limit={self.SEARCH_LIMIT}&appid={self.API_KEY}")
        if response.status_code == 200:
            return response
        else:
            ConnectionError(
                f"Failed to reach API: {response.status_code} status code returned.")
