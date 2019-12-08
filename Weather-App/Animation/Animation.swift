//
//  Animation.swift
//  Weather-App
//
//  Created by Mac OS on 2019-12-05.
//  Copyright © 2019 Alven. All rights reserved.
//

import Foundation
import UIKit
class Animation: UIViewController
{
   //MARK: IBOutlets
    @IBOutlet weak var logo: UIImageView!
    
    //MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //200° * Double.pi/180 from degre to radian.
        let radians = CGFloat(200 * Double.pi/180)
        UIView.animate(withDuration: 2, delay: 5, options: [.curveEaseIn], animations: {
            //disiper.
            self.logo.alpha = 0
            self .logo.transform = CGAffineTransform(rotationAngle: radians).scaledBy(x: 3, y: 3)
        })

    }
  
}
