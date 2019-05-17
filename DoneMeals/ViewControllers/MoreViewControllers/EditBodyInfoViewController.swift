//
//  EditBodyInfoViewController.swift
//  DoneMeals
//
//  Created by RAK on 10/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import NotificationCenter

class EditBodyInfoViewController: UIViewController {
    
    var userInfo: UserInfo?
    
    var updateDataDelegate: UpdateDataDelegate?
    
    @IBOutlet weak var emailLabel: UILabel!
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
    @IBAction func tappedDoneButton(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, let age = ageButton.titleLabel?.text, let height = heightButton.titleLabel?.text, let weight = weightButton.titleLabel?.text else { return }
        let updateInfo: [String: Any] = ["name": name, "gender": maleButton.isSelected, "age": age, "height": height, "weight": weight]
        let uid = self.userInfo!.uid
        let service = APIService()
        service.updateUserInformation(uid: uid, information: updateInfo) { (error) in
            if error != nil {
                print(error!)
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EditBodyInfo"), object: nil)
            self.updateDataDelegate?.updateData()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    let coverView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coverView.backgroundColor = .black
        coverView.alpha = 0
        coverView.frame = view.bounds
        coverView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    
    func setupViews() {
        if let info = userInfo {
            self.emailLabel.text = info.email
            self.nameTextField.text = info.name
            self.maleButton.isSelected = info.gender
            self.femaleButton.isSelected = !info.gender
            self.ageButton.setTitle(String(info.age), for: .normal)
            self.heightButton.setTitle(String(info.height), for: .normal)
            self.weightButton.setTitle(String(info.weight), for: .normal)
        }
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
        self.navigationController?.view.addSubview(coverView)
        UIView.animate(withDuration: 0.3) { self.coverView.alpha = 0.6 }
    }

}


extension EditBodyInfoViewController: ValueSelectedDelegate {
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
    
extension EditBodyInfoViewController: DismissViewControllerDelegate {
    func removeCoverView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.coverView.alpha = 0
        }) { (bool) in
            self.coverView.removeFromSuperview()
        }
    }
}
