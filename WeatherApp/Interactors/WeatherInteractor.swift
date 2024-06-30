//
//  WeatherInteractor.swift
//  WeatherApp
//
//  Created by Jose Cruz on 30/06/2024.
//

import Foundation

protocol WeatherService : AnyObject {
    func getWeatherSuccess(weather: WeatherModel)
    func getWeatherFailWithError(error: String)
}

class WeatherInteractor{
    
    weak var delegate : WeatherService?
    var weatherApiClient:WeatherStaticApiClient.Type = WeatherApiClient.self
    
    func getWeather(location: String) {
        
        if location.isEmpty{
            delegate?.getWeatherFailWithError(error: "ERROR_INVALID_LOCATION".localized())
            return
        }
        
        weatherApiClient.getWeatherData(location: location){ [weak self] response in
            guard let weatherData = response else{
                self?.delegate?.getWeatherFailWithError(error: "ERROR_UNEXPECTED".localized())
                return
            }
            
            let weather = WeatherModel(searchKey: location, cityName: weatherData.location.name, regionName: weatherData.location.region, temperature: weatherData.current.tempC, condition: weatherData.current.condition.text)
            self?.delegate?.getWeatherSuccess(weather: weather)
            return
            
        } failure: { [weak self] apiError in
            
            guard let error = apiError else{
                self?.delegate?.getWeatherFailWithError(error: "ERROR_UNEXPECTED".localized())
                return
            }
            
            switch error {
            case WeatherError.invalidURL:
                self?.delegate?.getWeatherFailWithError(error: "ERROR_INVALID_URL".localized())
                return
            case WeatherError.invalidResponse:
                self?.delegate?.getWeatherFailWithError(error: "ERROR_INVALID_RESPONSE".localized())
                return
            case WeatherError.invalidData:
                self?.delegate?.getWeatherFailWithError(error: "ERROR_INVALID_DATA".localized())
                return
            case WeatherError.invalidLocation:
                self?.delegate?.getWeatherFailWithError(error: "ERROR_INVALID_LOCATION".localized())
                return
            default:
                self?.delegate?.getWeatherFailWithError(error: "ERROR_UNEXPECTED".localized())
                return
            }
        }
        
        
        
    }
}
