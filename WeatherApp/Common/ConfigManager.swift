//
//  SecretManager.swift
//  WeatherApp
//
//  Created by Jose Cruz on 30/06/2024.
//

import Foundation
final class ConfigManager {
    
    static let sharedInstance: ConfigManager = {
        let instance = ConfigManager()
        return instance
    }()
    
    private(set) var apiKey: String!
    let weatherBaseURL = "https://api.weatherapi.com/v1/current.json"
    
    enum Keys {
        static let apikey = "API_KEY"
    }
    
    init() {
    }
    
    func configure() {
        guard let apiKey = Bundle.main.infoDictionary?[Keys.apikey] as? String, !apiKey.isEmpty else {
            fatalError("API Key is missing from config.")
        }
        self.apiKey = apiKey
    }
    
}
