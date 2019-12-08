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
            //show search bar on top.
            tableView.tableHeaderView = searchController.searchBar
            
            setupTapGesture()
            loadLoactionsFromCSV()
        }
        
        
        private func setupSearchController() {
            //creeate placeholder to search.
            searchController.searchBar.placeholder = "City or Country"
            //uppdate when it search.
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
            //search bar allways showing on top.
            searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
            searchController.searchBar.sizeToFit()
            searchController.searchBar.backgroundImage = UIImage()
        }
        //tape to dismiss.
        private func setupTapGesture() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
            self.tableView.backgroundView = UIView()
            self.tableView.backgroundView?.addGestureRecognizer(tap)
        }
        //using (@objc) befor my function becus #selector is an objectiv c style.
    @objc func tableTapped() {
            dismissView()
        }
        
        
        //MARK: Get Locations
        
        private func loadLoactionsFromCSV() {
            //if we have a path.
            if let path = Bundle.main.path(forResource: "location", ofType: "csv") {
                //pass the path to parseCSVAt function.
                parseCSVAt(url: URL(fileURLWithPath: path))
            }
        }
        
        private func parseCSVAt(url: URL) {
            
            do {
                //try to get data from passed url.
                let data = try Data(contentsOf: url)
                
                let dataEncoded = String(data: data, encoding: .utf8)
                // (/n) separateby line and (,) separateby string.
                if let dataArr = dataEncoded?.components(separatedBy: "\n").map({ $0.components(separatedBy: ",")}) {
                    
                    var i = 0
                    
                    for line in dataArr {
// line must have more than 2 objectwe need ["cityname","countrename","country cod"]
                        //and i shud start from secound line.
                        if line.count > 2 && i != 0 {
                            createLocation(line: line)
                        }
                        //add 1 to skep first line
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
                //chek if its not already in savedlocation array.
                if !savedLocations!.contains(location) {
                   // save the location in array.
                    savedLocations!.append(location)
                }
            } else {
                savedLocations = [location]
            }
            //the value in encod throws so using try? to handel the errors.
            userDefaults.set(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
            userDefaults.synchronize()
        }
        //avoiding to save same object twice.
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
        //filter the recived text.
        func filterContentForSearchText(searchText: String, scope: String = "All") {
            
            filteredLocations = allLocations.filter({ (location) -> Bool in
                return location.city.lowercased().contains(searchText.lowercased()) || location.country.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            //take the wirited text in place holder and send it to filterContentForSearchText.
            filterContentForSearchText(searchText: searchController.searchBar.text!)
        }
    }

    extension ChooseCityUIViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return filteredLocations.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // serch bar identifier = Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let location = filteredLocations[indexPath.row]
            //show city name and country name when we serch.
            cell.textLabel?.text = location.city
            cell.detailTextLabel?.text = location.country
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //deselect row when we selected.
            tableView.deselectRow(at: indexPath, animated: true)
            //save selected location to saveToUserDefaults func.
            saveToUserDefaults(location: filteredLocations[indexPath.row])
            //notife add new location
            delegate?.didAdd(newLocation: filteredLocations[indexPath.row])
            
            dismissView()
        }
        
    }


