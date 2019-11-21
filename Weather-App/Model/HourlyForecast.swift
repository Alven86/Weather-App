//
//  HourlyForecast.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-14.
//  Copyright © 2019 Alven. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
//get 3 var date ,temp,weather icon for 24 hours
class HourlyForecast {
    
    private var _date: Date!
    private var _temp: Double!
    private var _weatherIcon: String!
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    var temp: Double {
        if _temp == nil {
            _temp = 0.0
        }
        return _temp
    }
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    // create a Dictionary string=key object=valju
    init(weatherDictionary: Dictionary<String, AnyObject>) {
        
        let json = JSON(weatherDictionary)
       self._temp =  json["temp"].double
       self._date = currentDateFromUnix(unixDate: json["ts"].double!)
       self._weatherIcon = json["weather"]["icon"].stringValue
    }
    
    class func downloadHourlyForecastWeather(location: WeatherLocation, completion: @escaping (_ hourlyForecast: [HourlyForecast]) -> Void) {
            
            //daynamik url
            
        
        var HOURLYFORECAST_URL: String!
               
               if !location.isCurrentLocation {
                   HOURLYFORECAST_URL = String(format: "https://api.weatherbit.io/v2.0/forecast/hourly?city=%@,SE&hours=24&key=8cb940790ebc4f2f9bfbe7bae20aa9ea",location.city, location.countryCode)
               } else {
                   HOURLYFORECAST_URL = CURRENTLOCATIONHOURLYFORECAST_URL
               }
               
            
            Alamofire.request(HOURLYFORECAST_URL).responseJSON { (response) in
                
                let result = response.result
                
                var forecastArray: [HourlyForecast] = []
                
                if result.isSuccess {
                    
                // all the 24 hour result
                    if let dictionary = result.value as? Dictionary<String, AnyObject> {
                        if let list = dictionary["data"] as? [Dictionary<String, AnyObject>] {
                            //for evry houer
                            for item in list {
                                let forecast = HourlyForecast(weatherDictionary: item)
                                //put on an array
                                forecastArray.append(forecast)
                            }
                            
                        }
                    }
                    
                    completion(forecastArray)
                } else {
                    completion(forecastArray)
                    print("no forecast data")
                }
                
                
            }
            
        }
        
        
    }

