//
//  AllLocationsTableViewController.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-22.
//  Copyright © 2019 Alven. All rights reserved.
//

import UIKit

protocol AllLocationsTableViewControllerDelegate {
    func didChooseLocation(atIndex: Int, shouldRefresh: Bool)
}

class AllLocationsTableViewController: UITableViewController {

    //MARK: IBOutlets
    @IBOutlet weak var tempSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var footerView: UIView!

    //MARK: Vars
       let userDefaults = UserDefaults.standard
       var savedLocations: [WeatherLocation]?
       var weatherData: [CityTempData]?
       
       var delegate: AllLocationsTableViewControllerDelegate?
       var shouldRefresh = false
       
       
       //MARK: View lifecycle
       override func viewDidLoad() {
           super.viewDidLoad()
           tableView.tableFooterView = footerView
           
           loadLocationsFromUserDefaults()
           loadTempFormatFromUserDefaults()
       }

       //MARK: IBActions
       @IBAction func tempSegmentValueChanged(_ sender: UISegmentedControl) {
           updateTempFormatInUserDefaults(newValue: sender.selectedSegmentIndex)
       }
       
       
       
       // MARK: - Table view data source
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if count = nil (??0)= return zero
           return weatherData?.count ?? 0
       }

       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainWeatherTableViewCell

           if weatherData != nil {
               cell.generateCell(weatherData: weatherData![indexPath.row])
           }
           
           return cell
       }
       
       //MARK: TableViewDelegate
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           tableView.deselectRow(at: indexPath, animated: true)
           delegate?.didChooseLocation(atIndex: indexPath.row, shouldRefresh: shouldRefresh)
           self.dismiss(animated: true, completion: nil)
       }
       
       override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          //first row is from our current location will not deleted.
           return indexPath.row != 0
       }
       
       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
           if editingStyle == .delete {
               let locationToDelete = weatherData?[indexPath.row]
               weatherData?.remove(at: indexPath.row)

               removeLocationFromSavedLocations(location: locationToDelete!.city)
               tableView.reloadData()
           }
       }
       
       private func removeLocationFromSavedLocations(location: String) {
           
           if savedLocations != nil {
            //go throw all object in savedlocation.
               for i in 0..<savedLocations!.count {
                   //get templocation for evry run.
                   let tempLocation = savedLocations![i]
                   //compary templocation to deleted location.
                   if tempLocation.city == location {
                       //remove.
                       savedLocations!.remove(at: i)
                      // save new changes.
                       saveNewLoactionsToUserDefaults()
                       //exit.
                       return
                   }
               }
           }
       }
       
       
       //MARK: UserDefaults
       
       private func saveNewLoactionsToUserDefaults() {
           shouldRefresh = true
           
           userDefaults.set(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
           userDefaults.synchronize()
       }

       
       private func loadLocationsFromUserDefaults() {
           if let data = userDefaults.value(forKey: "Locations") as? Data {
               savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
           }
       }
       
       private func updateTempFormatInUserDefaults(newValue: Int) {
           shouldRefresh = true
           userDefaults.set(newValue, forKey: "TempFormat")
           userDefaults.synchronize()
       }
       
       private func loadTempFormatFromUserDefaults() {
           
           if let index = userDefaults.value(forKey: "TempFormat") {
               tempSegmentOutlet.selectedSegmentIndex = index as! Int
           } else {
               tempSegmentOutlet.selectedSegmentIndex = 0
           }
       }


       //MARK: Navigation
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check if its the right segue
           if segue.identifier == "chooseLocationSeg" {
            //let viewcontroller(vc) acecc throw chooseLocationSeg to ChooseCityUIViewController.
               let vc = segue.destination as! ChooseCityUIViewController
            //this view set as ChooseCityUIViewController delegate.
               vc.delegate = self
           }
       }
       
   }


   extension AllLocationsTableViewController: ChooseCityUIViewControllerDelegate {
       func didAdd(newLocation: WeatherLocation) {
           shouldRefresh = true

           weatherData?.append(CityTempData(city: newLocation.city, temp: 0.0))
           tableView.reloadData()
       }
   }
