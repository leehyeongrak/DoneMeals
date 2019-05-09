//
//  AddViewController.swift
//  FOODOC
//
//  Created by RAK on 06/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    
    @IBOutlet weak var predictionContainerView: UIView!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        predictFood(image: image)
        print("Aasdasdadasda")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if let tbc = self.tabBarController as? TabBarController {
            tbc.selectedIndex = tbc.index
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func predictFood(image: UIImage) {
        let model = Food101()
        let size = CGSize(width: 299, height: 299)
        
        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }
        
        guard let result = try? model.prediction(image: buffer) else {
            fatalError("Prediction failed!")
        }
        
        let confidence = result.foodConfidence["\(result.classLabel)"]! * 100.0
        let converted = String(format: "%.2f", confidence)
        
        predictionContainerView.isHidden = false
        mealImageView.image = image
        predictionLabel.text = "\(result.classLabel) - \(converted) %"
        
    }
}
