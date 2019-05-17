//
//  TimeSelectViewController.swift
//  DoneMeals
//
//  Created by RAK on 15/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class TimeSelectViewController: UIViewController {
    
    var dismissViewControllerDelegate: DismissViewControllerDelegate?
    var valueSelectedDelegate: ValueSelectedDelegate?
    
    var segueIdentifier: String?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBAction func tappedSetButton(_ sender: UIButton) {
        let date = pickerView.date
        switch segueIdentifier {
        case "SetBreakfastSegue":
            UserDefaults.standard.set(date, forKey: "breakfastTime")
        case "SetLunchSegue":
            UserDefaults.standard.set(date, forKey: "lunchTime")
        case "SetDinnerSegue":
            UserDefaults.standard.set(date, forKey: "dinnerTime")
        default:
            return
        }
        
        valueSelectedDelegate?.valueSelected(segueIdentifier: segueIdentifier!, value: nil)
        
        self.dismissViewControllerDelegate?.removeCoverView()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCancelButton(_ sender: UIButton) {
        self.dismissViewControllerDelegate?.removeCoverView()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
    }
    
    private func setupViews() {
        switch segueIdentifier {
        case "SetBreakfastSegue":
            titleLabel.text = "아침"
            if let date = UserDefaults.standard.object(forKey: "breakfastTime") as? Date {
                pickerView.setDate(date, animated: true)
            }
        case "SetLunchSegue":
            titleLabel.text = "점심"
            if let date = UserDefaults.standard.object(forKey: "lunchTime") as? Date {
                pickerView.setDate(date, animated: true)
            }
        case "SetDinnerSegue":
            titleLabel.text = "저녁"
            if let date = UserDefaults.standard.object(forKey: "dinnerTime") as? Date {
                pickerView.setDate(date, animated: true)
            }
        default:
            return
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
