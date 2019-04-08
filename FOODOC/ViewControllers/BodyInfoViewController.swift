//
//  BodyInfoViewController.swift
//  FOODOC
//
//  Created by RAK on 06/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import FirebaseAuth

class BodyInfoViewController: UIViewController {
    
    var userLoggedOutDelegate: UserLoggedOutDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBAction func tappedMaleButton(_ sender: UIButton) {
        maleButton.isSelected = !maleButton.isSelected
        femaleButton.isSelected = !femaleButton.isSelected
    }
    @IBAction func tappedFemaleButton(_ sender: UIButton) {
        maleButton.isSelected = !maleButton.isSelected
        femaleButton.isSelected = !femaleButton.isSelected
    }
    
    @IBAction func tappedAgeButton(_ sender: UIButton) {
    }
    @IBAction func tappedHeightButton(_ sender: UIButton) {
    }
    @IBAction func tappedWeightButton(_ sender: UIButton) {
    }
    
    @IBAction func tappedLogoutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true) {
                self.userLoggedOutDelegate?.userLoggedOut()
            }
        } catch {
            print(error)
        }
    }
    @IBAction func tappedStartButton(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
