//
//  SceneDelegate.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-05.
//  Copyright © 2019 Alven. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let currentweather = CurrentWeather()
        currentweather.getCurrentWeather { (success) in
            if success{print("city is: ",currentweather.city,currentweather.currentTemp)}
        }
        
        
        }
    }

    
