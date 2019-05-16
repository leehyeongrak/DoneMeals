//
//  DateSelectViewController.swift
//  FOODOC
//
//  Created by RAK on 23/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class DateSelectViewController: UIViewController {
    
    var dismissViewControllerDelegate: DismissViewControllerDelegate?
    var dateSelectedDelegate: DateSelectedDelegate?
    
    var bld = Bld.Breakfast
    
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    
    @IBAction func tappedBreakfastButton(_ sender: UIButton) {
        breakfastButton.isSelected = true
        lunchButton.isSelected = false
        dinnerButton.isSelected = false
        bld = .Breakfast
    }
    @IBAction func tappedLunchButton(_ sender: UIButton) {
        breakfastButton.isSelected = false
        lunchButton.isSelected = true
        dinnerButton.isSelected = false
        bld = .Lunch
    }
    @IBAction func tappedDinnerButton(_ sender: UIButton) {
        breakfastButton.isSelected = false
        lunchButton.isSelected = false
        dinnerButton.isSelected = true
        bld = .Dinner
    }
    
    @IBOutlet weak var pickerView: UIDatePicker!
    
    @IBAction func tappedSetButton(_ sender: UIButton) {
        let date = pickerView.date
        dateSelectedDelegate?.dateSelected(date: date, bld: bld)
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
}
