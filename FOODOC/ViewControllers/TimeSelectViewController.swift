//
//  TimeSelectViewController.swift
//  FOODOC
//
//  Created by RAK on 15/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class TimeSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBAction func tappedSetButton(_ sender: UIButton) {
    }
    @IBAction func tappedCancelButton(_ sender: UIButton) {
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
