//
//  weatherLocation.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-21.
//  Copyright © 2019 Alven. All rights reserved.
//

import Foundation

struct WeatherLocation: Codable, Equatable {
    var city: String!
    var country: String!
    var countryCode: String!
    var isCurrentLocation: Bool!
}
