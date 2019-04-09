//
//  PickerViewController.swift
//  FOODOC
//
//  Created by RAK on 08/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {

    var segueIdentifier: String?
    var values: Array<Int> = []
    var decimalPointValues: Array<Int> = Array(0...9)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBAction func tappedSelectButton(_ sender: UIButton) {
    }
    @IBAction func tappedCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch segueIdentifier {
        case "SelectAgeSegue":
            titleLabel.text = "나이"
            unitLabel.text = "살"
            pickerView.selectRow(20, inComponent: 0, animated: false)
        case "SelectHeightSegue":
            titleLabel.text = "키"
            unitLabel.text = "센티미터"
            pickerView.selectRow(130, inComponent: 0, animated: false)
        case "SelectWeightSegue":
            titleLabel.text = "체중"
            unitLabel.text = "킬로그램"
            pickerView.selectRow(40, inComponent: 0, animated: false)
        default:
            titleLabel.text = ""
            unitLabel.text = ""
        }
    }
}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(values[row])
        default:
            return ".\(decimalPointValues[row])"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch segueIdentifier {
        case "SelectAgeSegue":
            return 1
        default:
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return values.count
        default:
            return decimalPointValues.count
        }
        
    }

}
