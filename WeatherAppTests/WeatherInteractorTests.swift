//
//  WeatherInteractorTests.swift
//  WeatherAppTests
//
//  Created by Jose Cruz on 30/06/2024.
//


import XCTest
@testable import WeatherApp

class MockWeatherService: WeatherService {
    var weatherSuccessCalled = false
    var weatherFailCalled = false
    var weather: WeatherModel?
    var error: String?
    
    func getWeatherSuccess(weather: WeatherModel) {
        weatherSuccessCalled = true
        self.weather = weather
    }
    
    func getWeatherFailWithError(error: String) {
        weatherFailCalled = true
        self.error = error
    }
}

class MockWeatherApiClient: WeatherStaticApiClient {
    
    static var shouldReturnError = false
    static var error: WeatherError?
    static var weatherData: WeatherData?

    static func reset() {
        shouldReturnError = false
        error = nil
        weatherData = nil
    }

    static func getWeatherData(location: String, completion: @escaping (WeatherData?) -> Void,
                        failure: @escaping (Error?) -> Void) {
        if shouldReturnError {
            failure(error)
        } else {
            completion(weatherData)
        }
    }
}

class WeatherInteractorTests: XCTestCase {
    
    var interactor: WeatherInteractor!
    var mockService: MockWeatherService!
    
    override func setUpWithError() throws {
        interactor = WeatherInteractor()
        mockService = MockWeatherService()
        interactor.delegate = mockService
        interactor.weatherApiClient = MockWeatherApiClient.self
        MockWeatherApiClient.reset()
    }
    
    override func tearDownWithError() throws {
        interactor = nil
        mockService = nil
        super.tearDown()
    }
    
    func testGetWeatherSuccess() {
        
        let location = "New York"
        let weatherData = WeatherData(location: Location(name: "New York", region: "NY"), current: Weather(tempC: 20.0, condition: Condition(code: 00, text: "Sunny")))
        MockWeatherApiClient.weatherData = weatherData
        
        interactor.getWeather(location: location)
        
        XCTAssertTrue(mockService.weatherSuccessCalled)
        XCTAssertEqual(mockService.weather?.cityName, "New York")
        XCTAssertEqual(mockService.weather?.regionName, "NY")
        XCTAssertEqual(mockService.weather?.temperature, 20.0)
        XCTAssertEqual(mockService.weather?.condition, "Sunny")
    }
    
    func testGetWeatherFailure_invalidLocation() {
       
        let location = "######"
        MockWeatherApiClient.shouldReturnError = true
        MockWeatherApiClient.error = .invalidLocation
        
        interactor.getWeather(location: location)
        
        XCTAssertTrue(mockService.weatherFailCalled)
        XCTAssertEqual(mockService.error, "ERROR_INVALID_LOCATION".localized())
    }
    
    func testGetWeatherFailureEmptyLocation() {
        
        let location = ""
        MockWeatherApiClient.shouldReturnError = true
        MockWeatherApiClient.error = WeatherError.invalidLocation
        
        
        interactor.getWeather(location: location)
        
        
        XCTAssertTrue(mockService.weatherFailCalled)
        XCTAssertEqual(mockService.error, "ERROR_INVALID_LOCATION".localized())
    }
}
