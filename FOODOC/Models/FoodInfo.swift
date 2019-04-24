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
    var imageURL: String?
    var nutrientInfo: NutrientInfo
}
