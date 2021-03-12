import requests
import datetime

BASE = 'http://192.168.1.104:5000/'

response = requests.get(BASE + 'forecast/56.119/-3.9')

if response.status_code == 200:
    json = response.json()
    # print(list(map(lambda item: item['temp']
    #    ['max'], json['forecast']['week'])))
    print(json['forecast']['week'][0])
    print(json['analytics'])

else:
    print(response.status_code)
