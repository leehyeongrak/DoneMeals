//
//  NutrientInfo.swift
//  DoneMeals
//
//  Created by RAK on 24/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation

struct NutrientInfo {
    var calorie: Int
    var carbo: Int
    var prot: Int
    var fat: Int
    var sugars: Double
    var sodium: Double
    var cholesterol: Double
    var satFat: Double
    var transFat: Double
    
    var dictionary: [String: Any] {
        return ["calorie": calorie,
                "carbo": carbo,
                "prot": prot,
                "fat": fat,
                "sugars": sugars,
                "sodium": sodium,
                "cholesterol": cholesterol,
                "satFat": satFat,
                "transFat": transFat]
    }
    
    init(dictionary: [String: Any]) {
        self.calorie = dictionary["calorie"] as! Int
        self.carbo = dictionary["carbo"] as! Int
        self.prot = dictionary["prot"] as! Int
        self.fat = dictionary["fat"] as! Int
        self.sugars = dictionary["sugars"] as! Double
        self.sodium = dictionary["sodium"] as! Double
        self.cholesterol = dictionary["cholesterol"] as! Double
        self.satFat = dictionary["satFat"] as! Double
        self.transFat = dictionary["transFat"] as! Double
    }
}
