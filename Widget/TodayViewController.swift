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
    
    @IBOutlet weak var titleLabel: UILabel!
    
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
        updateRecommendedViews()
        completionHandler(NCUpdateResult.newData)
    }
    
    func updateRecommendedViews() {
        if let groupUserDefaults = UserDefaults(suiteName: "group.com.rak.DoneMeals") {
            if let user = groupUserDefaults.value(forKey: "user") as? String, let calorie = groupUserDefaults.value(forKey: "calorie") as? Int, let carbo = groupUserDefaults.value(forKey: "carbo") as? Int, let prot = groupUserDefaults.value(forKey: "prot") as? Int, let fat = groupUserDefaults.value(forKey: "fat") as? Int, let recommendedCalorie = groupUserDefaults.value(forKey: "recommendedCalorie") as? Double, let recommendedCarbo = groupUserDefaults.value(forKey: "recommendedCarbo") as? Double, let recommendedProt = groupUserDefaults.value(forKey: "recommendedProt") as? Double, let recommendedFat = groupUserDefaults.value(forKey: "recommendedFat") as? Double {
                
                self.titleLabel.text = "\(user)님의 일일섭취량"
                self.recommendedCalorieLabel.text = "\(calorie)kcal/\(Int(round(recommendedCalorie)))kcal"
                self.recommendedCarboLabel.text = "\(carbo)g/\(Int(round(recommendedCarbo)))g"
                self.recommendedProtLabel.text = "\(prot)g/\(Int(round(recommendedProt)))g"
                self.recommendedFatLabel.text = "\(fat)g/\(Int(round(recommendedFat)))g"
                
                self.calorieProgressView.setProgress(Float(Double(calorie)/recommendedCalorie), animated: true)
                self.carboProgressView.setProgress(Float(Double(carbo)/recommendedCarbo), animated: true)
                self.protProgressView.setProgress(Float(Double(prot)/recommendedProt), animated: true)
                self.fatProgressView.setProgress(Float(Double(fat)/recommendedFat), animated: true)
                
                
            } else {
                print("헤헤")
            }
        } else {
            print("노노")
        }
    }
    
}
