//
//  TodayViewController.swift
//  Widget
//
//  Created by RAK on 27/05/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var recommendContainerView: UIView!
    
    @IBOutlet weak var recommendedCalorieLabel: UILabel!
    @IBOutlet weak var recommendedCarboLabel: UILabel!
    @IBOutlet weak var recommendedProtLabel: UILabel!
    @IBOutlet weak var recommendedFatLabel: UILabel!
    
    @IBOutlet weak var calorieProgressView: UIProgressView!
    @IBOutlet weak var carboProgressView: UIProgressView!
    @IBOutlet weak var protProgressView: UIProgressView!
    @IBOutlet weak var fatProgressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transform = calorieProgressView.transform.scaledBy(x: 1, y: 3)
        calorieProgressView.transform = transform
        carboProgressView.transform = transform
        protProgressView.transform = transform
        fatProgressView.transform = transform
        // Do any additional setup after loading the view from its nib.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
