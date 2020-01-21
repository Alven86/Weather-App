//
//  CurrentWeather.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-10.
//  Copyright © 2019 Alven. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    // using private var to not be accecible from other files in project.
    private var _city: String!
    private var _date: Date!
    private var _currentTemp: Double!
    private var _feelsLike: Double!
    private var _uv: Double!
    
    private var _weatherType: String!
    private var _pressure: Double! //mb
    private var _humidity: Double! //%
    private var _windSpeed: Double! // meter/sec
    private var _weatherIcon: String!
    private var _visibility: Double! // KM
    private var _sunrise: String!
    private var _sunset: String!
    //public var
    var city: String {
        //if the _city ==nill return empty string to avoid crashing.
        if _city == nil {
            _city = ""
        }
        return _city
    }
    var date: Date {
        if _date == nil {
            //using Date() to return current Date.
            _date = Date()
        }
        return _date
    }
    var uv: Double {
        if _uv == nil {
            _uv = 0.0
        }
        return _uv
    }
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    var sunset: String {
        if _sunset == nil {
            _sunset = ""
        }
        return _sunset
    }
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    var feelsLike: Double {
        if _feelsLike == nil {
            _feelsLike = 0.0
        }
        return _feelsLike
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    var pressure: Double {
        if _pressure == nil {
            _pressure = 0.0
        }
        return _pressure
    }
    var humidity: Double {
        if _humidity == nil {
            _humidity = 0.0
        }
        return _humidity
    }
    var windSpeed: Double {
        if _windSpeed == nil {
            _windSpeed = 0.0
        }
        return _windSpeed
    }
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    var visibility: Double {
        if _visibility == nil {
            _visibility = 0.0
        }
        return _visibility
    }

    
    func getCurrentWeather(location: WeatherLocation, completion: @escaping(_ success: Bool)->Void) {
        
        var LOCATIONAPI_URL: String!
        
        if !location.isCurrentLocation {
            //API URL.
            LOCATIONAPI_URL = String(format: "https://api.weatherbit.io/v2.0/current?city=%@,%@&key=16569e45275243c9bf09c351b3372172", location.city, location.countryCode)
            
        } else {
            LOCATIONAPI_URL = CURRENTLOCATION_URL
        }
        
        //Alamofire send request to API URL and recive a JSON respons.
        Alamofire.request(LOCATIONAPI_URL).responseJSON { (response) in
            //chek if any result in response.
            let result = response.result
            //if ther is result.
            if result.isSuccess {
                //using swiftyJSON to convert to JSON.
                let json = JSON(result.value)
                
             //  print(json)
                
                //acces the values to set the varibels.
                self._city = json["data"][0]["city_name"].stringValue
                self._date = currentDateFromUnix(unixDate: json["data"][0]["ts"].double)
                self._weatherType = json["data"][0]["weather"]["description"].stringValue
                
                self._currentTemp = getTempBasedOnSettings(celsious: json["data"][0]["temp"].double ?? 0.0)
                self._feelsLike = getTempBasedOnSettings(celsious: json["data"][0]["app_temp"].double ?? 0.0)
                self._pressure = json["data"][0]["pres"].double
                self._humidity = json["data"][0]["rh"].double
                self._windSpeed = json["data"][0]["wind_spd"].double
                self._weatherIcon = json["data"][0]["weather"]["icon"].stringValue
                self._visibility = json["data"][0]["vis"].double
                self._uv = json["data"][0]["uv"].double
                self._sunrise = json["data"][0]["sunrise"].stringValue
                self._sunset = json["data"][0]["sunset"].stringValue
                
                completion(true)
                
            } else {
                self._city = location.city
                completion(false)
                print("no rsult found for current location")
            }
            
            
        }
        
        
    }
    
    
}
