//
//  Constants.swift
//  WeatherProject
//
//  Created by Ekaterina Bastrikina on 11/10/2025.
//

import Foundation

struct Constants {
    
    struct weatherAPI {
        static let apiKey = "d9dadc1da3344caca6a133203251110"
        static let baseURLString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&aqi=no&q="
        static let cityURLString = "https://api.weatherapi.com/v1/search.json?key=\(apiKey)&q="
    }

}
