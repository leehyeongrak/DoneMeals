//
//  NutrientTableViewCell.swift
//  DoneMeals
//
//  Created by RAK on 21/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class NutrientTableViewCell: UITableViewCell {
    @IBOutlet weak var nutrientNameLabel: UILabel!
    
    @IBOutlet weak var nutrientValueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

