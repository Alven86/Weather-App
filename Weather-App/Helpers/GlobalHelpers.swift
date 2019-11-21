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
