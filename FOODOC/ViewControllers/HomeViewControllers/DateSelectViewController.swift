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
    
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    
    @IBOutlet weak var pickerView: UIDatePicker!
    
    @IBAction func tappedSetButton(_ sender: UIButton) {
    }
    
    @IBAction func tappedCancelButton(_ sender: UIButton) {
        self.dismissViewControllerDelegate?.removeCoverView()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
