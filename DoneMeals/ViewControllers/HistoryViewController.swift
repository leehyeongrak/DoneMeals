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
    
    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        setupCalendarView()
    }
    
    private func setupCalendarView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 dd일"
        selectedDateLabel.text = dateFormatter.string(from: Date())
        
        service.fetchMeals(of: Date()) { (list, error) in
            if error != nil {
                return
            }
            self.mealList = list ?? []
            self.foodCollectionView.reloadData()
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
        dateFormatter.dateFormat = "yyyy년 M월 dd일"
        selectedDateLabel.text = dateFormatter.string(from: date)
        
        service.fetchMeals(of: date) { (list, error) in
            if error != nil {
                return
            }
            self.mealList = list ?? []
            self.foodCollectionView.reloadData()
        }
    }
}
