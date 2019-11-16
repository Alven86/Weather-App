//
//  WeatherView.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-16.
//  Copyright © 2019 Alven. All rights reserved.
//

import UIKit

class WeatherView: UIView {

   //MARK: IBOutlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var cityNameLable: UILabel!
    @IBOutlet weak var dateLabl: UILabel!
    @IBOutlet weak var weatherInfoLable: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    
   
    //MARK: Vars
    var currentWeather: CurrentWeather!
    var weeklyWeatherForecastData: [WeeklyWeatherForecast] = []
    var dailyWeatherForecastData: [HourlyForecast] = []
   // var weatherInfoData: [WeatherInfo] = []
    
    //MARK: INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        mainInit()
    }

    
    private func mainInit() {
        
        Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setupTableView()
        setupHourlyCollectionView()
        setupInfoCollectionView()
    }
    
    
     private func setupTableView() {
           
            
            
        }
        
        private func setupHourlyCollectionView() {
            
            
            
        }
        
        private func setupInfoCollectionView() {
        
            
            
        }
        
    func refreshData() {
           setupCurrentWeather()
        //   setupWearherInfo()
         //  infoCollectionView.reloadData()
       }
       
       private func setupCurrentWeather() {
              
              cityNameLable.text = currentWeather.city
        dateLabl.text = "Today, \(currentWeather.date.shortDate())"
              
        tempLabel.text = "\(currentWeather.currentTemp)"
              weatherInfoLable.text = currentWeather.weatherType
          }
    
}
