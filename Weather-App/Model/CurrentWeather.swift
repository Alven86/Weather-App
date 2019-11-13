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
class CurrentWeather{
    
    
    
    
    
   class func getCurrentWeather(){
        let LOCATIONAPI_URL = "https://api.weatherbit.io/v2.0/current?city=Stockholm,SE&key=8cb940790ebc4f2f9bfbe7bae20aa9ea"
        Alamofire.request(LOCATIONAPI_URL).responseJSON { (response) in
            
            
            let result = response.result
            if result.isSuccess {
                let json = JSON(result.value)
                print(json)
                
                
            }else {print("no result found for current location") }
        }
        
    }
}
