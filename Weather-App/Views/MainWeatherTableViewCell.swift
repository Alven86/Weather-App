//
//  MainWeatherTableViewCell.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-26.
//  Copyright © 2019 Alven. All rights reserved.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    //standart function
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   //standart function
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func generateCell(weatherData: CityTempData) {
        
        cityLabel.text = weatherData.city
        //make text smaller to fit.
        cityLabel.adjustsFontSizeToFitWidth = true
        //%.0f = no dacimal value typ = doubel.
        //%@ = placeholder for text.
        tempLabel.text = String(format: "%.0f %@", weatherData.temp, returnTempFormatFromUserDefaults())
    }

}
