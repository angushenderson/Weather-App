import requests

BASE = 'http://192.168.1.104:5000/'
# response = requests.get(BASE + 'city/56.119/-3.9')
# response = requests.get(BASE + '/search-suggestions/stirling')
response = requests.get(BASE + 'forecast/37.7749/-122.4194')
print(response.url)
if response.status_code == 200:
    json = response.json()
    # print(json['forecast']['current']['weather'][0]['description'])
    print(json['forecast']['current'])
else:
    print(response.status_code)

response = requests.get(BASE + 'forecast/56.119/-3.9')
if response.status_code == 200:
    json = response.json()
    print(len(json['forecast']['rain_hour']))
else:
    print(response.status_code)


# response = requests.get(BASE + 'search-suggestions/san fra')
# if response.status_code == 200:
#     json = response.json()
#     # print(json)
# else:
#     print(response.status_code)

# response = requests.get(BASE + 'city/56.119/-3.9')
# if response.status_code == 200:
#     json = response.json()
#     # print(json)
# else:
#     print(response.status_code)
