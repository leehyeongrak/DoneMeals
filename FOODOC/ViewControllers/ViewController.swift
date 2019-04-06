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
        }
    }
    
    @objc func presentLoginViewController() {
        if let welcomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") {
            let navigationController = UINavigationController(rootViewController: welcomeViewController)
            present(navigationController, animated: true, completion: nil)
        }
    }


}

