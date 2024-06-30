//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Jose Cruz on 30/06/2024.
//

import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: Weather
}

struct Location: Codable{
    let name: String
    let region: String
}

struct Weather: Codable{
    let tempC: Double
    let condition: Condition
}

struct Condition: Codable{
    let code: Int
    let text: String
}

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidLocation
}
