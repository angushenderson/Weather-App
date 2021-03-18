from flask import Flask, request
from flask_restful import Resource, Api
from json import dumps
from flask_jsonpify import jsonify
from API import open_weather


app = Flask(__name__)
api = Api(app)


class Forecast(Resource):
    """
    Full forecast
    """

    def get(self, lat, lon):
        location = open_weather.Location(coords=(lat, lon))
        forecast = open_weather.Forecast(location)
        print(forecast)
        return jsonify(forecast.forecast)


class LocationNameSearch(Resource):
    """
    Get location suggestions based on a partially or fully complete city name
    """

    def get(self, city):
        location = open_weather.Location()
        suggested_names = location.search_suggestions(city)
        print(suggested_names)
        names = [n['name'] for n in suggested_names]
        location_names = location.name_search(max(set(names), key=names.count))
        print(location_names)
        return jsonify({'locations': location_names})


class CityFromCoords(Resource):
    """
    Get city name from coordinates
    """

    def get(self, lat, lon):
        location = open_weather.Location()
        city = location.get_city_name(lat, lon)
        return jsonify({'locations': city})


api.add_resource(Forecast, '/forecast/<string:lat>/<string:lon>')
api.add_resource(LocationNameSearch, '/search-suggestions/<string:city>')
api.add_resource(CityFromCoords, '/city/<string:lat>/<string:lon>')

print(app.url_map)

if __name__ == '__main__':
    app.run(host='192.168.1.104', debug=True)
