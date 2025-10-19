//
//  WeatherModel.swift
//  WeatherProject
//
//  Created by Ekaterina Bastrikina on 11/10/2025.
//

import Foundation

struct WeatherModel {
    let city: String
    let temperature: Double
    let condition: Int
    let conditionDescription: String
    let iconURL: String
    
    var temperatureString: String {
            return String(format: "%.f °C", temperature)
        }

}

