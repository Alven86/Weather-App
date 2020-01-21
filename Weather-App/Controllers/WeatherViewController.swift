//
//  WeatherViewController.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-15.
//  Copyright © 2019 Alven. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var weatherScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    //MARK: Vars
        let userDefaults = UserDefaults.standard
        
        var locationManager: CLLocationManager?
        var currentLocation: CLLocationCoordinate2D!
        
        var allLocations: [WeatherLocation] = []
        var allWeatherViews: [WeatherView] = []
        var allWeatherData: [CityTempData] = []

        var shouldRefresh = true
        
        //MARK: ViewLifecycle
        override func viewDidLoad() {
            super.viewDidLoad()

            locationManagerStart()
            weatherScrollView.delegate = self
        }
        
        override func viewDidAppear(_ animated: Bool) {

            if shouldRefresh {
                allLocations = []
                allWeatherViews = []
                removeViewsFromScrollView()
                
                locationAuthCheck()
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super .viewWillDisappear(animated)
            locationManagerStop()
        }
        
        //MARK: Download Weather
        
        private func getWeather() {
            loadLocationsFromUserDefaults()
            createWeatherViews()
            addWeatherToScrollView()
            setPageControllPageNumber()
        }
        
        private func removeViewsFromScrollView() {
            for view in weatherScrollView.subviews {
                view.removeFromSuperview()
            }
        }
        
        private func createWeatherViews() {
            // creat view for every location.
            for _ in allLocations {
                allWeatherViews.append(WeatherView())
            }
        }
        
        private func addWeatherToScrollView() {
             //looping throw all views object and add to scrollview.
            for i in 0..<allWeatherViews.count {

                let weatherView = allWeatherViews[i]
                let location = allLocations[i]
                
                getCurrentWeather(weatherView: weatherView, location: location)
                getWeeklyWeather(weatherView: weatherView, location: location)
                getHourlyWeather(weatherView: weatherView, location: location)
                //y=0 becus view star from upp corner.
                //x = xpos its multiple to keyp the views beside each other virtekle.
                let xPos = self.view.frame.width * CGFloat(i)
                weatherView.frame = CGRect(x: xPos, y: 0, width: weatherScrollView.bounds.width, height: weatherScrollView.bounds.height)
                //add view to scroll view.
                weatherScrollView.addSubview(weatherView)
                //size of view.
                weatherScrollView.contentSize.width = weatherView.frame.width * CGFloat(i + 1)//+1 margen betwen the views.
            }
        }
        
        
        private func getCurrentWeather(weatherView: WeatherView, location: WeatherLocation) {
            //get info from API.
            weatherView.currentWeather = CurrentWeather()
            //add to weatherview.
            weatherView.currentWeather.getCurrentWeather(location: location) { (success) in
                //refresh data
                weatherView.refreshData()
                self.generateWeatherList()
            }
        }
        
        
        private func getWeeklyWeather(weatherView: WeatherView, location: WeatherLocation) {
            
            WeeklyWeatherForecast.downloadWeeklyWeatherForecast(location: location) { (weatherForecasts) in
                weatherView.weeklyWeatherForecastData = weatherForecasts
                weatherView.tableView.reloadData()
            }
        }
        

        private func getHourlyWeather(weatherView: WeatherView, location: WeatherLocation) {
            
            HourlyForecast.downloadHourlyForecastWeather(location: location) { (weatherForecasts) in
                weatherView.dailyWeatherForecastData = weatherForecasts
                weatherView.hourlyCollectionView.reloadData()
            }
        }
        
        
        //MARK: LoadLocations from User Defaults
        private func loadLocationsFromUserDefaults() {
            
            let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)

            
            if let data = userDefaults.value(forKey: "Locations") as? Data {
                allLocations = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
                //insert current location allways first in index 0.
                allLocations.insert(currentLocation, at: 0)

            } else {
                print("no user data in user defaults")
                allLocations.append(currentLocation)
            }
        }
        
        //MARK: PageControll
        
        private func setPageControllPageNumber() {
            pageControl.numberOfPages = allWeatherViews.count
        }
        
        private func updatePageControlSelectedPage(currentPage: Int) {
            pageControl.currentPage = currentPage
        }
        
        //MARK: Location Manager
        
        private func locationManagerStart() {
            //didint started yet.
            if locationManager == nil {
                //initialize.
                locationManager = CLLocationManager()
                //best accurace for phone position.
                locationManager!.desiredAccuracy = kCLLocationAccuracyBest
                //Premition to use GPS .
                locationManager!.requestWhenInUseAuthorization()
                locationManager!.delegate = self
            }
            
            locationManager!.startMonitoringSignificantLocationChanges()
        }
        //if leving the app it stop monitoring to save battre.
        private func locationManagerStop() {
            if locationManager != nil {
                locationManager!.stopMonitoringSignificantLocationChanges()
            }
        }
        //check if the device have the authorization to use location.
        private func locationAuthCheck() {
            while true  {
                
              //   locationManagerStart()
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
               
                currentLocation = locationManager!.location?.coordinate
                
                if currentLocation != nil {
                    //sett the location.
                    LocationService.shared.latitude = currentLocation.latitude
                    LocationService.shared.logitude = currentLocation.longitude
                    // download wether after getting position.
                    getWeather()
                    break;
                } //else {
             //       locationAuthCheck()
                   // break;
              //  }
            } else {
                //ask for authorization.
                locationManager?.requestWhenInUseAuthorization()
                //re call the function.
               // locationAuthCheck()
            }
        }
         }
        private func generateWeatherList() {
            //empty array.
            allWeatherData = []
            //looping throw weather view seperate citys.
            for weatherView in allWeatherViews {
                //create city temp data object and add to allweatherdata array.
                allWeatherData.append(CityTempData(city: weatherView.currentWeather.city, temp: weatherView.currentWeather.currentTemp))
            }
        }
        
        
        //MARK: Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "allLocationSeg" {
                let vc = segue.destination as! AllLocationsTableViewController
                vc.weatherData = allWeatherData
                vc.delegate = self
            }
        }

    }

    extension WeatherViewController: AllLocationsTableViewControllerDelegate {
        func didChooseLocation(atIndex: Int, shouldRefresh: Bool) {
            
            let viewNumber = CGFloat(integerLiteral: atIndex)
            let newOffset = CGPoint(x: (weatherScrollView.frame.width + 1.0) * viewNumber, y: 0)
            
            weatherScrollView.setContentOffset(newOffset, animated: true)
            updatePageControlSelectedPage(currentPage: atIndex)
            
            self.shouldRefresh = shouldRefresh
        }
    }

    extension WeatherViewController: CLLocationManagerDelegate {
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Faild to get location, \(error.localizedDescription)")
        }
    }


    extension WeatherViewController: UIScrollViewDelegate {
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            //devide contentOffset.x / scrollView width
            let value = scrollView.contentOffset.x / scrollView.frame.size.width
            updatePageControlSelectedPage(currentPage: Int(round(value)))
        }
    }
