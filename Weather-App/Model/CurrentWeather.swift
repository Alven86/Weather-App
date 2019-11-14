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

// in this class i will chose wich info ned to display.
class CurrentWeather{
    //using private var for security and will not be accebile from other files in project.
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
    
    //public var get display info from private var.
    var city: String {
           if _city == nil {
               _city = ""
           }
           return _city
       }
       var date: Date {
           if _date == nil {
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

    
    
    //functiont to use the information
    func getCurrentWeather(completion: @escaping(_ success: Bool)->Void) {
        
        //The API URL
        let LOCATIONAPI_URL = "https://api.weatherbit.io/v2.0/current?city=Stockholm,SE&key=8cb940790ebc4f2f9bfbe7bae20aa9ea"
        Alamofire.request(LOCATIONAPI_URL).responseJSON { (response) in
            
            
            let result = response.result
            if result.isSuccess {
                let json = JSON(result.value)
               // print(json)
                //acces the valus and set the vars.
                self._city = json["data"][0]["city_name"].stringValue
                self._date = currentDateFromUnix(unixDate: json["data"][0]["ts"].double)
                self._weatherType = json["data"][0]["weather"]["description"].stringValue
                self._currentTemp = json["data"][0]["temp"].double
                self._feelsLike = json["data"][0]["app_temp"].double
                self._pressure = json["data"][0]["pres"].double
                self._humidity = json["data"][0]["rh"].double
                self._windSpeed = json["data"][0]["wind_spd"].double
                self._weatherIcon = json["data"][0]["weather"]["icon"].stringValue
                self._visibility = json["data"][0]["vis"].double
                self._uv = json["data"][0]["uv"].double
                self._sunrise = json["data"][0]["sunrise"].stringValue
                self._sunset = json["data"][0]["sunset"].stringValue
            //Bool success return the information
                completion(true)
                               
                           } else {
                              // self._city = location.city
                       //Bool fail  return message
                               completion(false)
                              print("no result found for current location") }
        }
        
    }
}
