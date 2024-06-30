//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Jose Cruz on 30/06/2024.
//

import UIKit

class WeatherViewController: UIViewController {

    private let weatherView = WeatherView()
    private let weatherInteractor = WeatherInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherView.weatherViewDelegate = self
        weatherInteractor.delegate = self
        
        configureUI()
        
    }
    
    private func configureUI() {
        title = "VIEW_TITLE".localized()
        let backgroundImage = UIImage(named: "background")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = self.view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.isUserInteractionEnabled = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        view.addSubview(weatherView)
        
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}


extension WeatherViewController: WeatherDelegate {
    func searchWeather(location: String) {
        weatherInteractor.getWeather(location: location)
    }
}


extension WeatherViewController: WeatherService{
    func getWeatherSuccess(weather: WeatherModel) {
        weatherView.addLocation(toHistory: weather.searchKey)
        
        
        let description = NSMutableAttributedString()

        description.append(NSAttributedString(string: "DESCRIPTION_DISPLAYING_WEATHER".localized() + weather.cityName))
        description.append(NSAttributedString(string: "DESCRIPTION_REGION".localized() +  weather.regionName ))
        description.append(NSAttributedString(string: "DESCRIPTION_TEMPERATURE".localized() + "\(weather.temperature) °C"))
        description.append(NSAttributedString(string: "DESCRIPTION_CONDITION".localized() +  weather.condition))

        let alertController = UIAlertController(title: "ALERT_TITLE_SUCCESS".localized(), message: description.string, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func getWeatherFailWithError(error: String) {
        //      TODO - ADD localizization
        let alertController = UIAlertController(title: "ERROR".localized(), message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
