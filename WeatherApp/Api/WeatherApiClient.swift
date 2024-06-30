//
//  WeatherApiClient.swift
//  WeatherApp
//
//  Created by Jose Cruz on 30/06/2024.
//

import Foundation


protocol WeatherStaticApiClient {
    static func getWeatherData(location: String, completion: @escaping (WeatherData?) -> Void,
                        failure: @escaping (Error?) -> Void)
}

class WeatherApiClient: WeatherStaticApiClient{
    
    static func getWeatherData(location: String, completion: @escaping (WeatherData?) -> Void,
                        failure: @escaping (Error?) -> Void) {
        
        guard let apiKey = ConfigManager.sharedInstance.apiKey else {
            failure(WeatherError.invalidURL)
            return
        }
        
        var urlComponents = URLComponents(string: ConfigManager.sharedInstance.weatherBaseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "Key", value: apiKey),
            URLQueryItem(name: "q", value: location)
        ]
        
        guard let url = urlComponents?.url else {
            failure(WeatherError.invalidURL)
            return
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { (data, res, err) in
            
            guard let response = res as? HTTPURLResponse else {
                failure(WeatherError.invalidResponse)
                return
            }
            
            if response.statusCode == 400 {
                failure(WeatherError.invalidLocation)
                return
            }
            
            if response.statusCode != 200 {
                failure(WeatherError.invalidResponse)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do{
                let decodedWeatherData = try decoder.decode(WeatherData.self, from: data!)
                completion(decodedWeatherData)
                return
            }catch{
                failure(WeatherError.invalidData)
                return
            }
            
        }.resume()        
    }
}
