//
//  ManualAddViewController.swift
//  FOODOC
//
//  Created by RAK on 23/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class ManualAddViewController: UIViewController {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodIntakeTextField: UITextField!
    @IBOutlet weak var intakeDateButton: UIButton!
    
    @IBOutlet weak var nutrientTableView: UITableView!
    
    @IBAction func tappedDoneButton(_ sender: UIBarButtonItem) {
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
