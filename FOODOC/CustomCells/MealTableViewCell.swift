//
//  MealTableViewCell.swift
//  FOODOC
//
//  Created by RAK on 20/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    var mealList: Array<FoodInfo> = [] {
        didSet {
            self.foodCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var mealTimeLabel: UILabel!
    @IBOutlet weak var recommendedAmountLabel: UILabel!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    @IBOutlet weak var nilCoverView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MealTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mealList.count == 0 {
            nilCoverView.isHidden = false
        } else {
            nilCoverView.isHidden = true
        }
        
        return mealList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as? FoodCollectionViewCell else { return UICollectionViewCell() }
//        let bgImage = UIImageView()
//        bgImage.image = UIImage(named: "1")
//        bgImage.contentMode = .scaleAspectFill
        let food = mealList[indexPath.row]
        let nutrient = food.nutrientInfo
        let calorie = nutrient.carbo * 4 + nutrient.prot * 4 + nutrient.fat * 9
        cell.food = food
        cell.foodNameLabel.text = food.name
        cell.calorieLabel.text = "\(calorie)kcal"
//        cell.backgroundView = bgImage

        return cell
    }
    
    
}

extension MealTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
