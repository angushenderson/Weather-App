import requests
import datetime

BASE = 'http://192.168.1.104:5000/'

response = requests.get(BASE + 'forecast/56.119/-3.9')

if response.status_code == 200:
    json = response.json()
    print(json['forecast']['week'][0])

else:
    print(response.status_code)
