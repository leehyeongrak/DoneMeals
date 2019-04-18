//
//  UserInfo.swift
//  FOODOC
//
//  Created by RAK on 16/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation

struct UserInfo {
    var uid: String
    var email: String
    var name: String
    var gender: Bool
    var age: Int
    var height: Double
    var weight: Double
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as! String
        self.name = dictionary["name"] as! String
        self.gender = dictionary["gender"] as! Bool
        self.age = Int(dictionary["age"] as! String)!
        self.height = Double(dictionary["height"] as! String)!
        self.weight = Double(dictionary["weight"] as! String)!
    }
}
