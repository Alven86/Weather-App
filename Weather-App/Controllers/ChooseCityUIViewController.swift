//
//  ChooseCityUIViewController.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-22.
//  Copyright © 2019 Alven. All rights reserved.
//

import UIKit
protocol ChooseCityUIViewControllerDelegate {
    func didAdd(newLocation: WeatherLocation)
}
class ChooseCityUIViewController: UIViewController {

    
    //MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Vars
        var allLocations:[WeatherLocation] = []
        var filteredLocations: [WeatherLocation] = []
        
        let searchController = UISearchController(searchResultsController: nil)
        
        let userDefaults = UserDefaults.standard
        var savedLocations: [WeatherLocation]?
        var delegate: ChooseCityUIViewControllerDelegate?
        
        
        //MARK: View life cycle
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            loadFromUserDefaults()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.tableFooterView = UIView()
            
            setupSearchController()
            tableView.tableHeaderView = searchController.searchBar
            
            setupTapGesture()
            loadLoactionsFromCSV()
        }
        
        
        private func setupSearchController() {
            searchController.searchBar.placeholder = "City or Country"
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
            
            searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
            searchController.searchBar.sizeToFit()
            searchController.searchBar.backgroundImage = UIImage()
        }
        
        private func setupTapGesture() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
            self.tableView.backgroundView = UIView()
            self.tableView.backgroundView?.addGestureRecognizer(tap)
        }
        
        @objc func tableTapped() {
            dismissView()
        }
        
        
        //MARK: Get Locations
        
        private func loadLoactionsFromCSV() {
            if let path = Bundle.main.path(forResource: "location", ofType: "csv") {
                parseCSVAt(url: URL(fileURLWithPath: path))
            }
        }
        
        private func parseCSVAt(url: URL) {
            
            do {
                let data = try Data(contentsOf: url)
                let dataEncoded = String(data: data, encoding: .utf8)
                
                if let dataArr = dataEncoded?.components(separatedBy: "\n").map({ $0.components(separatedBy: ",")}) {
                    
                    var i = 0
                    
                    for line in dataArr {

                        if line.count > 2 && i != 0 {
                            createLocation(line: line)
                        }
                        i += 1
                    }
                }
                
            } catch {
                print("Error reading CSV file, ", error.localizedDescription)
            }
        }
        
        private func createLocation(line: [String]) {
            allLocations.append(WeatherLocation(city: line.first!, country: line[1], countryCode: line.last!, isCurrentLocation: false))
        }
        

        //MARK: UserDefaults
        
        private func saveToUserDefaults(location: WeatherLocation) {
            
            if savedLocations != nil {
                
                if !savedLocations!.contains(location) {
                    savedLocations!.append(location)
                }
            } else {
                savedLocations = [location]
            }
            
            userDefaults.set(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
            userDefaults.synchronize()
        }
        
        private func loadFromUserDefaults() {
            
            if let data = userDefaults.value(forKey: "Locations") as? Data {
                savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            }
        }
        
        
        private func dismissView() {
            if searchController.isActive {
                searchController.dismiss(animated: true) {
                    self.dismiss(animated: true)
                }
            } else {
                self.dismiss(animated: true)
            }
        }

    }

    extension ChooseCityUIViewController: UISearchResultsUpdating {
        
        func filterContentForSearchText(searchText: String, scope: String = "All") {
            
            filteredLocations = allLocations.filter({ (location) -> Bool in
                return location.city.lowercased().contains(searchText.lowercased()) || location.country.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            filterContentForSearchText(searchText: searchController.searchBar.text!)
        }
    }

    extension ChooseCityUIViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return filteredLocations.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let location = filteredLocations[indexPath.row]
            cell.textLabel?.text = location.city
            cell.detailTextLabel?.text = location.country
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            saveToUserDefaults(location: filteredLocations[indexPath.row])
            delegate?.didAdd(newLocation: filteredLocations[indexPath.row])
            
            dismissView()
        }
        
    }


