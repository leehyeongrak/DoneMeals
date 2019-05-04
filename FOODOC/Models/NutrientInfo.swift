//
//  NutrientInfo.swift
//  FOODOC
//
//  Created by RAK on 24/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation

struct NutrientInfo {
//    var nid: String
    var carbo: Double
    var prot: Double
    var fat: Double
    var sugars: Double
    var sodium: Double
    var cholesterol: Double
    var satFat: Double
    var transFat: Double
    
    var dictionary: [String: Any] {
        return ["carbo": carbo,
                "prot": prot,
                "fat": fat,
                "sugars": sugars,
                "sodium": sodium,
                "cholesterol": cholesterol,
                "satFat": satFat,
                "transFat": transFat]
    }
    
    init(dictionary: [String: Any]) {
        self.carbo = dictionary["carbo"] as! Double
        self.prot = dictionary["prot"] as! Double
        self.fat = dictionary["fat"] as! Double
        self.sugars = dictionary["sugars"] as! Double
        self.sodium = dictionary["sodium"] as! Double
        self.cholesterol = dictionary["cholesterol"] as! Double
        self.satFat = dictionary["satFat"] as! Double
        self.transFat = dictionary["transFat"] as! Double
    }
}
