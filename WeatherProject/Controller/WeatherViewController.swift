//
//  ViewController.swift
//  WeatherProject
//
//  Created by Ekaterina Bastrikina on 11/10/2025.
//

import UIKit

class WeatherViewController: UIViewController, UISearchBarDelegate {
        
    var weatherManager = WeatherManager()
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionText: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        weatherManager.fetchWeather(cityName: "Москва")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let searchVC = storyboard.instantiateViewController(identifier: "CitySearchViewController") as? CitySearchViewController {
            searchVC.delegate = self
            searchVC.modalPresentationStyle = .fullScreen
            present(searchVC, animated: false)
        }
        
    }

}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.city
            self.conditionText.text = weather.conditionDescription
            
            
            if let url = URL(string: weather.iconURL) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.weatherImageView.image = image
                        }
                    }
                }.resume()
            }
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension WeatherViewController: CitySearchDelegate {
    
    func didSelectCity(_ city: String) {
        weatherManager.fetchWeather(cityName: city)
    }
    
}
