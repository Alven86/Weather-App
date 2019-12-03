//
//  GlobalHelpers.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-14.
//  Copyright © 2019 Alven. All rights reserved.
//

import Foundation
import UIKit
//put unixDate in date or display the current date to avoid crash.
func currentDateFromUnix(unixDate: Double?) -> Date? {
    
    if unixDate != nil {
        return Date(timeIntervalSince1970: unixDate!)
    } else {
        return Date()
    }
    
}
//get the icon for wether
func getWeatherIconFor(_ type: String) -> UIImage? {
    return UIImage(named: type)
}

func fahrenheitFrom(celsius: Double) -> Double {
    return (celsius * 9/5) + 32
}

func getTempBasedOnSettings(celsious: Double) -> Double {
    
    let format = returnTempFormatFromUserDefaults()
    
    if format == TempFormat.celsius {
        return celsious
    } else {
        return fahrenheitFrom(celsius: celsious)
    }
}

func returnTempFormatFromUserDefaults() -> String {
    
    if let tempFormat = UserDefaults.standard.value(forKey: "TempFormat") {
        
        if tempFormat as! Int == 0 {
            return TempFormat.celsius
        } else {
            return TempFormat.fahrenheit
        }
        
    } else {
        return TempFormat.celsius
    }
}
