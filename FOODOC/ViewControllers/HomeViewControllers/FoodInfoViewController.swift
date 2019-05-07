//
//  FoodInfoViewController.swift
//  FOODOC
//
//  Created by RAK on 21/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class FoodInfoViewController: UIViewController {

    var food: FoodInfo?
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodIntakeLabel: UILabel!
    @IBOutlet weak var intakeDateLabel: UILabel!
    
    @IBOutlet weak var nutrientTableView: UITableView!
    
    @IBAction func tappedTrashButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: { (action) in
            let service = APIService()
            if let target = self.food {
                service.deleteMealInformation(fid: target.fid, completion: { (error) in
                    if error != nil {
                        return
                    }
                    if let rootViewController = self.navigationController?.viewControllers[0] as? ViewController {
                        rootViewController.fetchMealsOfToday{
                            rootViewController.updateRecommendedIntake()
                        }
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nutrientTableView.delegate = self
        nutrientTableView.dataSource = self
        nutrientTableView.allowsSelection = false
        
        setupViews()
    }
    
    private func setupViews() {
        if let food = self.food {
            self.foodNameLabel.text = food.name
            self.foodIntakeLabel.text = String(food.intake)
            
            let date = Date(timeIntervalSince1970: TimeInterval(exactly: food.createdTime)!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일"
            let dateText = dateFormatter.string(from: date)
            let bld = food.bld.rawValue
            self.intakeDateLabel.text = dateText + " " + bld
        }
    }
}

extension FoodInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientTableViewCell", for: indexPath) as? NutrientTableViewCell else { return UITableViewCell() }
        
        if let nutrient = food?.nutrientInfo {
            
            let percentage = Double(food!.intake)/Double(food!.defaultIntake)
            
            switch indexPath.row {
            case 0:
                cell.nutrientNameLabel.text = "칼로리"
                cell.nutrientValueLabel.text = "\(Int(round(Double(nutrient.calorie) * percentage)))kcal"
            case 1:
                cell.nutrientNameLabel.text = "탄수화물"
                cell.nutrientValueLabel.text = "\(Int(round(Double(nutrient.carbo) * percentage)))g"
            case 2:
                cell.nutrientNameLabel.text = "단백질"
                cell.nutrientValueLabel.text = "\(Int(round(Double(nutrient.prot) * percentage)))g"
            case 3:
                cell.nutrientNameLabel.text = "지방"
                cell.nutrientValueLabel.text = "\(Int(round(Double(nutrient.fat) * percentage)))g"
            case 4:
                cell.nutrientNameLabel.text = "당류"
                cell.nutrientValueLabel.text = "\(nutrient.sugars * percentage)g"
            case 5:
                cell.nutrientNameLabel.text = "나트륨"
                cell.nutrientValueLabel.text = "\(nutrient.sodium * percentage)mg"
            case 6:
                cell.nutrientNameLabel.text = "콜레스테롤"
                cell.nutrientValueLabel.text = "\(nutrient.cholesterol * percentage)mg"
            case 7:
                cell.nutrientNameLabel.text = "포화지방산"
                cell.nutrientValueLabel.text = "\(nutrient.satFat * percentage)g"
            default:
                cell.nutrientNameLabel.text = "트랜스지방산"
                cell.nutrientValueLabel.text = "\(nutrient.transFat * percentage)g"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
