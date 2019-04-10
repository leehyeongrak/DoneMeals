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
    
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var weightButton: UIButton!
    
    @IBAction func tappedMaleButton(_ sender: UIButton) {
        maleButton.isSelected = !maleButton.isSelected
        femaleButton.isSelected = !femaleButton.isSelected
    }
    @IBAction func tappedFemaleButton(_ sender: UIButton) {
        maleButton.isSelected = !maleButton.isSelected
        femaleButton.isSelected = !femaleButton.isSelected
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pickerViewController = segue.destination as? PickerViewController
        pickerViewController?.segueIdentifier = segue.identifier
        pickerViewController?.valueSelectedDelegate = self
        var values: Array<Int> = []
        switch segue.identifier {
        case "SelectAgeSegue":
            values = Array(1...100)
        case "SelectHeightSegue":
            values = Array(50...300)
        case "SelectWeightSegue":
            values = Array(30...200)
        default:
            return
        }
        pickerViewController?.values = values
    }

}

protocol ValueSelectedDelegate {
    func valueSelected(segueIdentifier: String, value: String)
}

extension BodyInfoViewController: ValueSelectedDelegate {
    func valueSelected(segueIdentifier: String, value: String) {
        switch segueIdentifier {
        case "SelectAgeSegue":
            print(value)
            self.ageButton.setTitle(value, for: .normal)
        case "SelectHeightSegue":
            self.heightButton.setTitle(value, for: .normal)
        case "SelectWeightSegue":
            self.weightButton.setTitle(value, for: .normal)
        default:
            return
        }
    }
}
