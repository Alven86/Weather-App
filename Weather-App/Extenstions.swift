//
//  Extenstions.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-16.
//  Copyright © 2019 Alven. All rights reserved.
//

import Foundation
extension Date {
    // creating format of month and day
    func shortDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
    
    //creating format of hour and minits
    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
   // creating format of week date
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    
}
