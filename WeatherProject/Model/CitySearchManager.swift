//
//  CitySearchManager.swift
//  WeatherProject
//
//  Created by Ekaterina Bastrikina on 16/10/2025.
//

import Foundation

struct City: Codable {
    let name: String
    let region: String?
    let country: String
}

struct CitySearchManager {
    
    func fetchCities(letters: String, completion: @escaping ([City]) -> Void) {
        let urlString = "\(Constants.weatherAPI.cityURLString)\(letters)"
        performRequest(urlString, completion: completion)
    }
    
    private func performRequest(_ urlString: String, completion: @escaping ([City]) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let safeData = data,
                  let cities = self.parseJSON(safeData) else { return }
            
            DispatchQueue.main.async {
                completion(cities)
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ data: Data) -> [City]? {
        do {
            let cities = try JSONDecoder().decode([City].self, from: data)
            return cities
        } catch {
            print(error)
            return nil
        }
    }
}
