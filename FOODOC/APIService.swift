//
//  APIService.swift
//  FOODOC
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
            if error != nil {
                completion(nil, error)
                return
            }
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
    
    func addFoodInformation(values: [String : Any], timestamp: Int, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uid).child("foods")
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
}

protocol APIServiceProtocol {
    func fetchUserInformation(completion: @escaping (UserInfo?, Error?) -> Void)
    func updateUserInformation(uid: String, information: [String: Any], completion: @escaping (Error?) -> Void)
    func addFoodInformation(values: [String: Any], timestamp: Int, completion: @escaping (Error?) -> Void)
}
