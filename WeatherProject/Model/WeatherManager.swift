//
//  WeatherManager.swift
//  WeatherProject
//
//  Created by Ekaterina Bastrikina on 11/10/2025.
//

import Foundation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    let weatherURL = Constants.weatherAPI.baseURLString
    
    
    func fetchWeather(cityName: String) {
        let lang = Locale.preferredLanguages.first?.prefix(2) ?? "en"
        print(lang)
        let urlString = "\(weatherURL)\(cityName)&lang=\(lang)"
        print(urlString)
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> WeatherModel? {
       let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let location = decodedData.location.name
            let currentTemperature = decodedData.current.temp_c
            let weatherCondition = decodedData.current.condition.code
            let iconURL = "https:\(decodedData.current.condition.icon)"
            let weatherDescription = decodedData.current.condition.text
         
    
            let weather = WeatherModel(
                city: location,
                temperature: currentTemperature,
                condition: weatherCondition,
                conditionDescription: weatherDescription,
                iconURL: iconURL
            )
            
            print("\(weatherCondition) \(weatherDescription) \(iconURL)")
            return weather
            
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
