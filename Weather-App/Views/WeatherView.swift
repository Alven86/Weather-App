//
//  WeatherView.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-17.
//  Copyright © 2019 Alven. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    
    //MARK: IBOutlets
       @IBOutlet var mainView: UIView!
       @IBOutlet weak var cityNameLabel: UILabel!
       @IBOutlet weak var dateLabel: UILabel!
       @IBOutlet weak var weatherInfoLabel: UILabel!
       @IBOutlet weak var tempLabel: UILabel!
       @IBOutlet weak var bottomContainer: UIView!
       @IBOutlet weak var hourlyCollectionView: UICollectionView!
       @IBOutlet weak var infoCollectionView: UICollectionView!
       @IBOutlet weak var tableView: UITableView!
       @IBOutlet weak var scrollView: UIScrollView!
    
    
    //MARK: Vars
    //one object
       var currentWeather: CurrentWeather!
    //many objects need array to hold
       var weeklyWeatherForecastData: [WeeklyWeatherForecast] = []
       var dailyWeatherForecastData: [HourlyForecast] = []
       var weatherInfoData: [WeatherInfo] = []
       
       //MARK: INITs
       override init(frame: CGRect) {
           super.init(frame: frame)
           
           mainInit()
       }
       //initializer
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           
           mainInit()
       }

       
       private func mainInit() {
           //setup weatherview manualy
           Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
           addSubview(mainView)
           mainView.frame = self.bounds
           mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
           
           setupTableView()
           setupHourlyCollectionView()
           setupInfoCollectionView()
       }
       
       //register WeatherTableViewCell to tableview
        private func setupTableView() {
           tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
           //get information
           tableView.delegate = self
           tableView.dataSource = self
           tableView.tableFooterView = UIView()
       }
       //register ForecastCollectionViewCell to hourlyCollectionView
        private func setupHourlyCollectionView() {
           hourlyCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
            //get information
        hourlyCollectionView.dataSource = self
       }
       //register InfoCollectionViewCell to infoCollectionView

       private func setupInfoCollectionView() {
           infoCollectionView.register(UINib(nibName: "InfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        //get information
           infoCollectionView.dataSource = self
       }
       
       func refreshData() {
        setupCurrentWeather()
        //infoCollectionView.reloadData()
          
       }
    
    
    
    private func setupCurrentWeather() {
        
        cityNameLabel.text = currentWeather.city
        dateLabel.text = "Today, \(currentWeather.date.shortDate())"
        
       // tempLabel.text = String(format: "%.0f%@", currentWeather.currentTemp, returnTempFormatFromUserDefaults())
        tempLabel.text = "\(currentWeather.currentTemp)"
        weatherInfoLabel.text = currentWeather.weatherType
    }
    
    

        
    }

    
    //confirm protocol delegate, datasorce
   extension WeatherView: UITableViewDataSource, UITableViewDelegate {
       //how many rows in tableview
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           return weeklyWeatherForecastData.count
       }
       // what type of cell to return
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
           
           cell.generateCell(forecast: weeklyWeatherForecastData[indexPath.row])
           
           return cell
       }
       
   }

// confirm protocol datasource for collectionview
   extension WeatherView: UICollectionViewDataSource {
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           
           if collectionView == hourlyCollectionView {
               return dailyWeatherForecastData.count
           } else {
               return weatherInfoData.count
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           if collectionView == hourlyCollectionView {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ForecastCollectionViewCell

               cell.generateCell(weather: dailyWeatherForecastData[indexPath.row])
               return cell
           } else {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InfoCollectionViewCell
               
               cell.generateCell(weatherInfo: weatherInfoData[indexPath.row])
               return cell
           }
       }
   }


    
    

   

