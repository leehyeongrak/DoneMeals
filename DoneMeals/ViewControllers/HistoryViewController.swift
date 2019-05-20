//
//  HistoryViewController.swift
//  DoneMeals
//
//  Created by RAK on 06/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import FSCalendar

class HistoryViewController: UIViewController {
    
    var mealList: Array<FoodInfo> = []
    let service = APIService()
    
    var user: UserInfo?
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    @IBOutlet weak var recommendedCalorieLabel: UILabel!
    @IBOutlet weak var recommendedCarboLabel: UILabel!
    @IBOutlet weak var recommendedProtLabel: UILabel!
    @IBOutlet weak var recommendedFatLabel: UILabel!
    
    @IBOutlet weak var calorieProgressView: UIProgressView!
    @IBOutlet weak var carboProgressView: UIProgressView!
    @IBOutlet weak var protProgressView: UIProgressView!
    @IBOutlet weak var fatProgressView: UIProgressView!
    
    @IBAction func tappedRefreshButton(_ sender: UIBarButtonItem) {
        setupCalendarView()
    }
    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        service.fetchUserInformation { (user, error) in
            self.user = user
            self.setupCalendarView()
        }
    }
    
    private func setupCalendarView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 dd일"
        selectedDateLabel.text = dateFormatter.string(from: Date())
        
        service.fetchMeals(of: Date()) { (list, error) in
            if error != nil {
                return
            }
            self.mealList = list ?? []
            self.foodCollectionView.reloadData()
            self.updateRecommendedIntake()
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

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as? FoodCollectionViewCell else { return UICollectionViewCell() }
        let food = mealList[indexPath.item]
        let nutrient = food.nutrientInfo
        let percentage = Double(food.intake)/Double(food.defaultIntake)
        cell.food = food
        cell.foodNameLabel.text = food.name
        cell.calorieLabel.text = "\(Int(round(Double(nutrient.calorie) * percentage)))kcal"
        print(food.imageURL)
        if food.imageURL != "" {
            let url = URL(string: food.imageURL)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    cell.foodImageView.image = UIImage(data: data!)
                }
                }.resume()
        }
        return cell
    }
    
    private func setupRecommendedIntake() {
        var calorie = 0
        var carbo = 0
        var prot = 0
        var fat = 0
        
        for meal in mealList {
            let percentage = Double(meal.intake) / Double(meal.defaultIntake)
            calorie += Int(round(Double(meal.nutrientInfo.calorie) * percentage))
            carbo += Int(round(Double(meal.nutrientInfo.carbo) * percentage))
            prot += Int(round(Double(meal.nutrientInfo.prot) * percentage))
            fat += Int(round(Double(meal.nutrientInfo.fat) * percentage))
        }
        
        if let user = self.user {
            self.recommendedCalorieLabel.text = "\(calorie)kcal/\(Int(round(user.recommendedIntake.calorie)))kcal"
            self.recommendedCarboLabel.text = "\(carbo)g/\(Int(round(user.recommendedIntake.carbo)))g"
            self.recommendedProtLabel.text = "\(prot)g/\(Int(round(user.recommendedIntake.prot)))g"
            self.recommendedFatLabel.text = "\(fat)g/\(Int(round(user.recommendedIntake.fat)))g"
            
            self.calorieProgressView.setProgress(Float(Double(calorie)/user.recommendedIntake.calorie), animated: true)
            self.carboProgressView.setProgress(Float(Double(carbo)/user.recommendedIntake.carbo), animated: true)
            self.protProgressView.setProgress(Float(Double(prot)/user.recommendedIntake.prot), animated: true)
            self.fatProgressView.setProgress(Float(Double(fat)/user.recommendedIntake.fat), animated: true)
            
            if self.calorieProgressView.progress == 1 {
                calorieProgressView.tintColor = UIColor.red
            } else {
                calorieProgressView.tintColor = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1)
            }
            if self.carboProgressView.progress == 1 {
                carboProgressView.tintColor = UIColor.red
            } else {
                carboProgressView.tintColor = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1)
            }
            if self.protProgressView.progress == 1 {
                protProgressView.tintColor = UIColor.red
            } else {
                protProgressView.tintColor = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1)
            }
            if self.fatProgressView.progress == 1 {
                fatProgressView.tintColor = UIColor.red
            } else {
                fatProgressView.tintColor = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1)
            }
        }
    }
}

extension HistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension HistoryViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 dd일"
        selectedDateLabel.text = dateFormatter.string(from: date)
        
        service.fetchMeals(of: date) { (list, error) in
            if error != nil {
                return
            }
            self.mealList = list ?? []
            self.foodCollectionView.reloadData()
            
            self.updateRecommendedIntake()
        }
    }
    
    func updateRecommendedIntake() {
        var calorie = 0
        var carbo = 0
        var prot = 0
        var fat = 0
        
        for meal in mealList {
            let percentage = Double(meal.intake) / Double(meal.defaultIntake)
            calorie += Int(round(Double(meal.nutrientInfo.calorie) * percentage))
            carbo += Int(round(Double(meal.nutrientInfo.carbo) * percentage))
            prot += Int(round(Double(meal.nutrientInfo.prot) * percentage))
            fat += Int(round(Double(meal.nutrientInfo.fat) * percentage))
        }
        
        if let user = self.user {
            self.recommendedCalorieLabel.text = "\(calorie)kcal/\(Int(round(user.recommendedIntake.calorie)))kcal"
            self.recommendedCarboLabel.text = "\(carbo)g/\(Int(round(user.recommendedIntake.carbo)))g"
            self.recommendedProtLabel.text = "\(prot)g/\(Int(round(user.recommendedIntake.prot)))g"
            self.recommendedFatLabel.text = "\(fat)g/\(Int(round(user.recommendedIntake.fat)))g"
            
            self.calorieProgressView.setProgress(Float(Double(calorie)/user.recommendedIntake.calorie), animated: true)
            self.carboProgressView.setProgress(Float(Double(carbo)/user.recommendedIntake.carbo), animated: true)
            self.protProgressView.setProgress(Float(Double(prot)/user.recommendedIntake.prot), animated: true)
            self.fatProgressView.setProgress(Float(Double(fat)/user.recommendedIntake.fat), animated: true)
            
            if self.calorieProgressView.progress == 1 {
                calorieProgressView.tintColor = UIColor.red
            } else {
                calorieProgressView.tintColor = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1)
            }
            if self.carboProgressView.progress == 1 {
                carboProgressView.tintColor = UIColor.red
            } else {
                carboProgressView.tintColor = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1)
            }
            if self.protProgressView.progress == 1 {
                protProgressView.tintColor = UIColor.red
            } else {
                protProgressView.tintColor = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1)
            }
            if self.fatProgressView.progress == 1 {
                fatProgressView.tintColor = UIColor.red
            } else {
                fatProgressView.tintColor = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1)
            }
        }
    }
    
}
