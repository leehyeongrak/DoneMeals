//
//  PickerViewController.swift
//  FOODOC
//
//  Created by RAK on 08/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {

    var valueSelectedDelegate: ValueSelectedDelegate?
    var dismissViewControllerDelegate: DismissViewControllerDelegate?
    
    var segueIdentifier: String?
    var values: Array<Int> = []
    var decimalPointValues: Array<Int> = Array(0...9)
    
    var selectedValue: Int = 0
    var selectedDecimalPointValue: Int = 0
    
    var existingValue: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBAction func tappedSelectButton(_ sender: UIButton) {
        var value = ""
        switch segueIdentifier {
        case "SelectAgeSegue":
            value = String(selectedValue)
        default:
            value = "\(selectedValue).\(selectedDecimalPointValue)"
        }
        valueSelectedDelegate?.valueSelected(segueIdentifier: segueIdentifier!, value: value)
        self.dismissViewControllerDelegate?.removeCoverView()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCancelButton(_ sender: UIButton) {
        self.dismissViewControllerDelegate?.removeCoverView()
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
            pickerView.selectRow(19, inComponent: 0, animated: false)
            selectedValue = 20
        case "SelectHeightSegue":
            titleLabel.text = "키"
            unitLabel.text = "센티미터"
            pickerView.selectRow(130, inComponent: 0, animated: false)
            selectedValue = 180
        case "SelectWeightSegue":
            titleLabel.text = "체중"
            unitLabel.text = "킬로그램"
            pickerView.selectRow(40, inComponent: 0, animated: false)
            selectedValue = 70
        default:
            titleLabel.text = ""
            unitLabel.text = ""
        }
    }
}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedValue = values[row]
        default:
            selectedDecimalPointValue = decimalPointValues[row]
        }
    }
    
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
