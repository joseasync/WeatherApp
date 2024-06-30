# WeatherApp

WeatherApp is a simple iOS application built with Swift and UIKit that provides current weather information. 
The app uses a custom simplified VIPER architecture.

<img width="100%" alt="Github" src="https://github.com/joseasync/WeatherApp/blob/main/Usage.gif" />
.

## Features

- Fetch and display current weather data for any location.
- User-friendly interface designed with UIKit.
- Universal App
- Languages: English and Portuguese(Brazil)

## Requirements

- iOS 15.0+

## Setup

1. Clone the repository:
    ```bash
    git clone https://github.com/joseasync/WeatherApp.git
    cd WeatherApp
    ```

2. Open the project in Xcode:
    ```bash
    open WeatherApp.xcodeproj
    ```

3. Add your API key:
    - Sign up for a free account at [WeatherAPI](https://www.weatherapi.com/).
    - Retrieve your API key.
    - Open the `secrets.xcconfig` file located in the project directory.
    - Add your API key in the following format:
        ```plaintext
        API_KEY = 999AAAA5555ac55e1w66w9999
        ```


## Usage

- Open the app and enter the location for which you want to see the weather.
- The app will display the current weather information for the entered location.

## API Request Workflow

The app makes API requests using the WeatherAPI endpoints. For more details on the API, refer to the [WeatherAPI documentation](https://www.weatherapi.com/docs/).

1. Sign up for a free account on [WeatherAPI](https://www.weatherapi.com/).
2. Retrieve your API key.
3. Add the API key to the `secrets.xcconfig` file as described in the Setup section.
4. The app will use this API key to make requests and fetch weather data.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

**Author:** José Cruz 
**GitHub:** [joseasync](https://github.com/joseasync)
