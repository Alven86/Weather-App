//
//  WeatherViewController.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-15.
//  Copyright © 2019 Alven. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var weatherScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    
    
    
    //MARK: ViewLifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
       
      //  print(weatherScrollView.bounds)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let weatherView = WeatherView()
        weatherView.frame = CGRect(x: 0, y: 0, width: weatherScrollView.bounds.width, height: weatherScrollView.bounds.height)
        weatherScrollView.addSubview(weatherView)
       
    GetCurrentWeather(weatherView: weatherView)
    getWeeklyWeather(weatherView: weatherView)
    getHourlyWeather(weatherView: weatherView)
     
    }
   //MARK: Download Weather
    private func GetCurrentWeather(weatherView: WeatherView){

        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather { (success) in
            
            weatherView.refreshData()
            
        }
    }
    private func getWeeklyWeather(weatherView: WeatherView){

        WeeklyWeatherForecast.downloadWeeklyWeatherForecast { (weatherForecasts) in
            weatherView.weeklyWeatherForecastData = weatherForecasts
            weatherView.tableView.reloadData()
        }
    }
    private func getHourlyWeather(weatherView: WeatherView){

        HourlyForecast.downloadHourlyForecastWeather { (weatherForecasts) in
                   weatherView.dailyWeatherForecastData = weatherForecasts
                   weatherView.hourlyCollectionView.reloadData()
               }
    }

}
