//
//  APIURLS.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-21.
//  Copyright © 2019 Alven. All rights reserved.
//

import Foundation

let CURRENTLOCATION_URL = "https://api.weatherbit.io/v2.0/current?&lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.logitude!)&key=8cb940790ebc4f2f9bfbe7bae20aa9ea"

let CURRENTLOCATIONWEEKLYFORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.logitude!)&days=7&key=8cb940790ebc4f2f9bfbe7bae20aa9ea"
let CURRENTLOCATIONHOURLYFORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.logitude!)&hours=24&key=8cb940790ebc4f2f9bfbe7bae20aa9ea"

