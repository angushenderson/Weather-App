# Full Stack Weather App

Full stack mobile weather app created with a Flutter front end and Python Flask backend, fetching forecast data and air quality data from the [OpenWeatherMap API](https://openweathermap.org/api). I've never found a Weather App that I've liked, so I decided to create my own!

## Screenshots

### Home screen

<img src="https://github.com/angushenderson/Weather-App/blob/main/README_images/HomeScreen.jpg?raw=true" width="400" />

### Weekly forecast screen

<img src="https://github.com/angushenderson/Weather-App/blob/main/README_images/WeeklyForecastScreen.jpg?raw=true" width="400" />

### Forecast graphs

<img src="https://github.com/angushenderson/Weather-App/blob/main/README_images/AmazingGraphs.jpg?raw=true" width="400" />

If you wish to try the app out for yourself, follow the [Getting Started guide](#getting-started) below.

## Getting Started

There are 2 parts to this project, the client application and the Flask server, so the setup will be split in 2 parts to cover each.

### Server setup

If you're interested in my design approach please read the [server design rationale](#server-design-rationale) section below. To get started, make sure you have Python version >= 3.8 installed. You can download it [here](https://www.python.org/downloads/).

- Before we get started we need to get an API key from OpenWeatherMap

  - Head to [the Open Weather Map API](https://openweathermap.org/api) and press the sign up button (orange text) in the header paragraph. From their, follow the sign up flow to create an account. Once set up, go to [the API keys page](https://home.openweathermap.org/api_keys), then generate a new API key. Keep this tab open, we'll come back to it later in the setup.

- In a terminal (or command line on windows), clone the Weather-App repository to the machine you wish to run the server on using `git clone https://github.com/angushenderson/Weather-App`

- Navigate to the cloned file location using `cd`. Once in the base file location called Weather-App, run `pip install -r requirements.txt` to install all the required dependencies.

- Open the `.env` file in either a terminal editor or regular text editor. There are 3 environment variables we need to set.

  - Set `OPEN_WEATHER_API_KEY` equal to your Open Weather Map API key we fetched earlier, e.g. `OPEN_WEATHER_API_KEY=d5330d9420e470fd5c43a7a5036e2e18`

  - Set `SERVER_ADDRESS` to your machine's local address. You can find this on Windows by entering `ipconfig` into the command line and finding your IPv4 Address or on Linux by entering `ifconfig` and finding your inet address under the wlan section. It should look something like `SERVER_ADDRESS=192.168.1.100`. Make sure to take a note of this address, we'll use it again later in the frontend setup. Note, by using the local address, you will only able to make server requests on your local network, however it should be possible to access the server anywhere by using either port forwarding on your router or using an ipv6 address. This isn't something I have tested or are familiar with so for the purposes of this setup guide I'm going to stick to using a local address. If you are deploying to a cloud provider, follow their setup instructions, however from my experience deploying to Google App Engine, using 127.0.0.1 works fine.

  - By default the `SERVER_PORT` environment variable is set to 8080. This is the default for Flask, however if this port is already in use on your system, feel free to change it, just make sure to take note of it for when we set up our frontend.

- With all our configurations configured we can run the server! In your console or terminal, make sure you are in the server folder (`Weather-App/server`), then run `python server.py`. This runs the Flask development server. I could have created a deployment server to improve security, speed and scalability however this was just a fun personal project so I have no real need or desire for any of those things at the moment. Flask does have a production ready server though, so feel free to check it out and set it up if you want to.

### Client setup

The app uses Flutter for its frontend, and we're going to use the Flutter CLI to install the app on your device.

- First, install Flutter. This setup is different for each OS, so I'll leave it to the experts at Google; take a look at this tutorial [here](https://flutter.dev/docs/get-started/install) to get started.

- With Flutter installed and configured we are ready to get going. If you are on a different machine to your server, clone the git repo again using the command `git clone https://github.com/angushenderson/Weather-App`. Navigate to the client folder within this repository (`Weather-App/client`) and open the `.env` file.

  - Enter the address of the server that you noted down earlier into the `SERVER_ADDRESS` variable. It should look something like: `SERVER_ADDRESS='192.168.1.100'`. If you have deployed this app to a cloud provider, either use the ip address they have provided you with, or the url they have provided you with, both will work fine.

  - If you changed the port that the server run's on, make sure to set the `SERVER_PORT` environment variable equal to this new port now, if not just leave it set to 5000 as provided. It should look like `SERVER_PORT='5000'`. If your `SERVER_ADDRESS` is a url, leave this environment variable as an empty string.

  - The `PROTOCOL` variable is the protocol used to make API requests. For simplicity, the development server is only designed to handle http requests, hence its set as such. If you change the Flask server to support https, make sure to change this environment variable to PROTOCOL='https'.

- With the app configured, we can install it onto your device! Plug your device into your computer so we can get started.

  - In your command line, navigate into the client directory `Weather-App/client`, then run `flutter run --release`. The release flag removes all of Flutter's development features to make the app run silky smooth.

- And that's it! You should now have a fully functioning Weather App running on your device!

## Server Design Rationale

I used a property based object approach for my Forecast class (the wrapper object for the OpenWeatherMap API) to reduce the number of API requests that need to be made to fetch an entire forecast, and hence improve response times. This approach would also be great for caching responses (something that realistically isn't necessary in a personal side project, however having the core structure to add this functionality in the future is pretty awesome in my opinion) or storing them permanently using the pickle module for historic information or user history (again, I didn't end up implementing this however the infrastructure that would allow this to happen).

Was the backend necessary? In the end, probably not. However I really wanted to build a full stack application and that's what I did. It was a really awesome project to work on and I learned a lot about what to do and also crucially, what not to do. I'll definitely have more full stack projects coming in the future!

## Deploying to Google Cloud App Engine

Personally, I deployed this app to Google Cloud App Engine so I could have access to the api anytime, removing the dependance of having my raspberry pi running all the time. If this is something you're interested in doing, I recommend finding guides yourself, as they will explain them way better than I could, a google search along the lines of "deploy flask app to google app engine" should set you off in the right direction. All the config necessary is already setup, you'll just need to create an app engine instance then deploy it using the command line. A base (pretty weak, but fully functional) app engine is available for free on Google Cloud which is pretty amazing, so I highly recommend at least giving it a shot if you're curious like me!

## Acknowledgments

- The brilliant UI design by [HUA on Dribbble](https://dribbble.com/tyronehua)
