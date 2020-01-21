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
    
    //initializer Dictionary string=key anyobject=value.
    init(weatherDictionary: Dictionary<String, AnyObject>) {
        
        let json = JSON(weatherDictionary)
        
        self._temp = getTempBasedOnSettings(celsious: json["temp"].double ?? 0.0)
        self._date = currentDateFromUnix(unixDate: json["ts"].double!)
        //the key is icon weather is another dictionare.
        self._weatherIcon = json["weather"]["icon"].stringValue
    }
    
    
    class func downloadHourlyForecastWeather(location: WeatherLocation, completion: @escaping (_ hourlyForecast: [HourlyForecast]) -> Void) {
        
        var HOURLYFORECAST_URL: String!
        
        if !location.isCurrentLocation {
            HOURLYFORECAST_URL = String(format: "https://api.weatherbit.io/v2.0/forecast/hourly?city=%@,%@&hours=24&key=16569e45275243c9bf09c351b3372172", location.city, location.countryCode)
            
        } else {
            HOURLYFORECAST_URL = CURRENTLOCATIONHOURLYFORECAST_URL
        }
        
        Alamofire.request(HOURLYFORECAST_URL).responseJSON { (response) in
            
            let result = response.result
            
            var forecastArray: [HourlyForecast] = []
            
            if result.isSuccess {
                

                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    //list is = clean hourly forcast without other info
                    if let list = dictionary["data"] as? [Dictionary<String, AnyObject>] {
                        //go throw every value in list.
                        for item in list {
                            //instance.
                            let forecast = HourlyForecast(weatherDictionary: item)
                            //add element to the end of array.
                            forecastArray.append(forecast)
                        }
                        
                    }
                }
                //return all object in array
                completion(forecastArray)
            } else {
                //return empty
                completion(forecastArray)
                print("no forecast data")
            }
            
            
        }
        
    }
    
    
}
