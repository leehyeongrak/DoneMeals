//
//  BodyInfoViewController.swift
//  DoneMeals
//
//  Created by RAK on 06/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import Firebase
import NotificationCenter

class BodyInfoViewController: UIViewController {
    
    var userLoggedOutDelegate: UserLoggedOutDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var weightButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if nameTextField.text == "" || ageButton.titleLabel?.text == "나이를 선택해주세요" || heightButton.titleLabel?.text == "키를 선택해주세요" || weightButton.titleLabel?.text == "체중을 선택해주세요" {
            let alert = UIAlertController(title: "시작하기 실패", message: "항목을 전부 입력해주세요", preferredStyle: .alert)
            present(alert, animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        guard let name = nameTextField.text, let age = ageButton.titleLabel?.text, let height = heightButton.titleLabel?.text, let weight = weightButton.titleLabel?.text else { return }
        let bodyInfo: [String: Any] = ["name": name, "gender": maleButton.isSelected, "age": age, "height": height, "weight": weight]
        let ref = Database.database().reference()
        
        ref.child("users").child(uid).updateChildValues(bodyInfo) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EditBodyInfo"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    let coverView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.layer.cornerRadius = 30
        startButton.layer.masksToBounds = true
        logoutButton.layer.cornerRadius = 30
        logoutButton.layer.masksToBounds = true
        
        coverView.backgroundColor = .black
        coverView.alpha = 0
        coverView.frame = view.bounds
        coverView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        nameTextField.delegate = self
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
        
        pickerViewController?.dismissViewControllerDelegate = self
        self.view.addSubview(coverView)
        UIView.animate(withDuration: 0.3) { self.coverView.alpha = 0.6 }
    }

}

protocol ValueSelectedDelegate {
    func valueSelected(segueIdentifier: String, value: Any?)
}

protocol DismissViewControllerDelegate {
    func removeCoverView()
}

extension BodyInfoViewController: ValueSelectedDelegate {
    func valueSelected(segueIdentifier: String, value: Any?) {
        if let value = value as? String {
            switch segueIdentifier {
            case "SelectAgeSegue":
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
}

extension BodyInfoViewController: DismissViewControllerDelegate {
    func removeCoverView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.coverView.alpha = 0
        }) { (bool) in
            self.coverView.removeFromSuperview()
        }
    }
}

extension BodyInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
