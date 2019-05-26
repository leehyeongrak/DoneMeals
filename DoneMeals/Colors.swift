//
//  Colors.swift
//  DoneMeals
//
//  Created by RAK on 25/05/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var themeColor: UIColor {
        return UIColor(red: 143/255, green: 195/255, blue: 31/255, alpha: 1)
    }
    
    static var gradientGreen: UIColor {
        return UIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1)
    }
}

extension UIView {
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
