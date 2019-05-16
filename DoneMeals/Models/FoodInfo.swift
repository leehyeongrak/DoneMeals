//
//  FoodInfo.swift
//  FOODOC
//
//  Created by RAK on 24/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation

struct FoodInfo {
    var fid: String
    var name: String
    var intake: Int
    var defaultIntake: Int
    var createdTime: Int
    var imageURL: String
    var nutrientInfo: NutrientInfo
    var bld: Bld
    
    init(fid: String, dictionary: [String: Any], nutrient: NutrientInfo) {
        self.fid = fid
        self.name = dictionary["name"] as! String
        self.intake = dictionary["intake"] as! Int
        self.defaultIntake = dictionary["defaultIntake"] as! Int
        self.createdTime = dictionary["createdTime"] as! Int
        self.imageURL = dictionary["imageURL"] as! String
        switch dictionary["bld"] as! String {
        case "아침":
            self.bld = .Breakfast
        case "점심":
            self.bld = .Lunch
        case "저녁":
            self.bld = .Dinner
        default:
            self.bld = .Breakfast
        }
        self.nutrientInfo = nutrient
    }
}

enum Bld: String {
    case Breakfast = "아침"
    case Lunch = "점심"
    case Dinner = "저녁"
}
