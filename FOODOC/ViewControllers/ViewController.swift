//
//  ViewController.swift
//  FOODOC
//
//  Created by RAK on 01/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserAuth()
    }
    
    func checkUserAuth() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(presentLoginViewController), with: nil, afterDelay: 0)
        } else {
            checkUserInfo()
        }
    }
    
    func checkUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            if let age = dictionary["age"] as? Int {
                if age == 0 {
                    self.presentBodyInfoViewController()
                } else {
                    
                }
            }
        })
    }
    
    @objc func presentLoginViewController() {
        if let welcomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            welcomeViewController.userLoggedInDelegate = self
            let navigationController = UINavigationController(rootViewController: welcomeViewController)
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    func presentBodyInfoViewController() {
        if let bodyInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "BodyInfoViewController") as? BodyInfoViewController {
            present(bodyInfoViewController, animated: true, completion: nil)
        }
    }

}

protocol UserLoggedInDelegate {
    func userLoggedIn()
}

extension ViewController: UserLoggedInDelegate {
    func userLoggedIn() {
        checkUserInfo()
    }
}
