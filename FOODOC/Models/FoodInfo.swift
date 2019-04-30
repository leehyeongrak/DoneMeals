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
    var amount: Double
    var createdTime: Date
    var imageURL: String
    var nutrientInfo: NutrientInfo
    
    init(fid: String, dictionary: [String: Any]) {
        self.fid = fid
        self.name = dictionary["name"] as! String
        self.amount = dictionary["amount"] as! Double
        self.createdTime = dictionary["createdTime"] as! Date
        self.imageURL = dictionary["imageURL"] as! String
        self.nutrientInfo = dictionary["nutrientInfo"] as! NutrientInfo
    }
}


