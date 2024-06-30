//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Jose Cruz on 30/06/2024.
//

import UIKit


protocol WeatherDelegate: AnyObject {
    func searchWeather(location: String)
}

class WeatherView: UIView {
    
    private let searchTextField = UISearchTextField()
    private let tableview = UITableView()
    private var inputLocations: [String]? = []
    private let weatherCell = "WeatherCell"
    
    weak var weatherViewDelegate: WeatherDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        searchTextField.delegate = self
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoder has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor.clear
        
        configureSearchField()
        configureTableView()
    }
    
    private func configureSearchField() {
        searchTextField.placeholder = "SEARCH_PLACEHOLDER".localized()
        
        addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTextField.widthAnchor.constraint(equalToConstant: 200),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            searchTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            searchTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 15)
        ])
        
    }
    
    private func configureTableView() {
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: weatherCell)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = UIColor.clear
        
        addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableview.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            tableview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
    }
}


extension WeatherView: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "SEARCH_PLACEHOLDER".localized()
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let location = searchTextField.text{
            weatherViewDelegate?.searchWeather(location: location)
        }
        
        searchTextField.text = ""
        textField.placeholder = "SEARCH_PLACEHOLDER".localized()
    }
    
}


extension WeatherView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let locations = inputLocations else { return UITableViewCell() }
        let location = locations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: weatherCell, for: indexPath)
        cell.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.3)
        cell.selectionStyle = .none
        cell.textLabel?.text = location
        cell.textLabel?.textColor = .label
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let locations = inputLocations else {return}
        weatherViewDelegate?.searchWeather(location: locations[indexPath.row])
    }
    
    func addLocation(toHistory searchKey: String){
        if  inputLocations != nil && !inputLocations!.contains(searchKey) {
            inputLocations?.append(searchKey)
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
}
