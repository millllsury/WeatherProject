//
//  WeatherData.swift
//  WeatherProject
//
//  Created by Ekaterina Bastrikina on 11/10/2025.
//

import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let name: String
}

struct Current: Codable {
    let temp_c: Double
    let condition: Condition
}

struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}




