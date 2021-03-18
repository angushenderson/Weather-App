import requests
import datetime

BASE = 'http://192.168.1.104:5000/'

response = requests.get(BASE + 'forecast/56.119/-3.9')
# response = requests.get(BASE + 'search-suggestions/stirl')

if response.status_code == 200:
    json = response.json()
    print(json)

else:
    print(response.status_code)
