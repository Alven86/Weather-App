//
//  WeatherViewController.swift
//  Weather-App
//
//  Created by Mac OS on 2019-11-15.
//  Copyright © 2019 Alven. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    
    
    
    //MARK: ViewLifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(scrollView.bounds)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let weatherView = WeatherView()
        
        weatherView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(weatherView)
        
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather { (success) in
            weatherView.refreshData()
        }
    }
   

}
