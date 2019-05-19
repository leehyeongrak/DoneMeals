//
//  APIService.swift
//  DoneMeals
//
//  Created by RAK on 18/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation
import Firebase

class APIService: APIServiceProtocol {
    func fetchUserInformation(completion: @escaping (UserInfo?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let userInfo = UserInfo(uid: uid, dictionary: dictionary)
                completion(userInfo, nil)
            }
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func updateUserInformation(uid: String, information: [String: Any], completion: @escaping (Error?) -> Void) {
        let updateInfo = information
        let ref = Database.database().reference()
        
        ref.child("users").child(uid).updateChildValues(updateInfo) { (error, ref) in
            if error != nil {
                print(error!)
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func addMealInformation(values: [String : Any], timestamp: Int, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uid).child("meals")
        let childRef = ref.childByAutoId()
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func fetchMealInformation(bld: Bld, completion: @escaping (Array<FoodInfo>?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uid).child("meals")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let values = snapshot.value as? [String: Any] else { return completion(nil, nil) }
            var list: Array<FoodInfo> = []
            for value in values {
                if let meal = value.value as? [String: Any] {
                    let nutrient = NutrientInfo(dictionary: meal["nutrientInfo"] as! [String: Any])
                    let food = FoodInfo(fid: value.key, dictionary: meal, nutrient: nutrient)
                    list.append(food)
                }
            }
            completion(list, nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func deleteMealInformation(fid: String, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uid).child("meals").child(fid)
        
        ref.removeValue { (error, ref) in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func uploadImageData(image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmSS"
        let result = formatter.string(from: date)
        
        let storageRef = Storage.storage().reference().child(uid).child("meal_images").child("\(result).jpg")
        if let data = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(data, metadata: nil) { (metaData, error) in
                if error != nil {
                    completion(nil, error!)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        completion(nil, error!)
                        return
                    }
                    
                    if let imageURL = (url?.absoluteString) {
                        completion(imageURL, nil)
                    }
                })
            }
        }
    }
}

protocol APIServiceProtocol {
    func fetchUserInformation(completion: @escaping (UserInfo?, Error?) -> Void)
    func updateUserInformation(uid: String, information: [String: Any], completion: @escaping (Error?) -> Void)
    func addMealInformation(values: [String: Any], timestamp: Int, completion: @escaping (Error?) -> Void)
    func fetchMealInformation(bld: Bld, completion: @escaping (Array<FoodInfo>?, Error?) -> Void)
    func deleteMealInformation(fid: String, completion: @escaping (Error?) -> Void)
    func uploadImageData(image: UIImage, completion: @escaping (String?, Error?) -> Void)
}
