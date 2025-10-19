//
//  CitySearchViewController.swift
//  WeatherProject
//
//  Created by Ekaterina Bastrikina on 12/10/2025.
//

import UIKit

 
protocol CitySearchDelegate: AnyObject {
    func didSelectCity(_ city: String)
}

import UIKit

class CitySearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: CitySearchDelegate?
    
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var citySearchManager = CitySearchManager()
    var filteredCities: [City] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        citySearchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        citySearchBar.becomeFirstResponder()
    }

    // MARK: - UISearchBarDelegate

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredCities.removeAll()
            tableView.reloadData()
            return
        }

        citySearchManager.fetchCities(letters: searchText) { [weak self] cities in
            guard let self = self else { return }
            self.filteredCities = cities
            self.tableView.reloadData()
        }
    }


    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let city = searchBar.text {
            delegate?.didSelectCity(city)
            dismiss(animated: true)
        }
        
        
    }

    @objc func dismissSearch() {
        citySearchBar.resignFirstResponder()
        dismiss(animated: false)
    }

    // MARK: - UITableViewDataSource / Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrototypeCell", for: indexPath)
        let city = filteredCities[indexPath.row]
        if let region = city.region {
            cell.textLabel?.text = "\(city.name), \(region), \(city.country)"
        } else {
            cell.textLabel?.text = "\(city.name), \(city.country)"
        }
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = filteredCities[indexPath.row]
        delegate?.didSelectCity(selectedCity.name)
        dismiss(animated: true)
    }
}
