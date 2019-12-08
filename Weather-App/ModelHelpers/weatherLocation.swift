//
//  weatherLocation.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-21.
//  Copyright © 2019 Alven. All rights reserved.
//

import Foundation
// (Equatable protocol using to compare betwen two location) Returns a Boolean value indicating whether two values are equal.
// Codable protocol A type that can be used as a key for encoding and decoding.
struct WeatherLocation: Codable, Equatable {
    var city: String!
    var country: String!
    var countryCode: String!
    var isCurrentLocation: Bool!
}
