//
//  FoodCollectionViewCell.swift
//  DoneMeals
//
//  Created by RAK on 20/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    
    var food: FoodInfo?
    
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
        self.infoContainerView.clipsToBounds = true
        self.infoContainerView.layer.cornerRadius = 10
        self.infoContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    override func prepareForReuse() {
        foodImageView.image = UIImage(named: "Sample")
        foodNameLabel.text = ""
        calorieLabel.text = ""
    }
}
