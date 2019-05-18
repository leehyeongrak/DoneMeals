//
//  PredictViewController.swift
//  DoneMeals
//
//  Created by RAK on 11/05/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import NotificationCenter

class PredictViewController: UIViewController {
    
    @IBOutlet weak var predictionContainerView: UIView!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(completeCameraTask), name: NSNotification.Name("CompleteCameraTask"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func completeCameraTask() {
        if let tbc = self.tabBarController as? TabBarController {
            tbc.tabBar.isHidden = false
            tbc.selectedIndex = tbc.index
            self.predictionContainerView.isHidden = true
        }
    }
}

extension PredictViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        var food: String = ""
        predictFood(image: image) { (result) in
            food = result
        }
        self.dismiss(animated: true) {
            let alert = UIAlertController(title: nil, message: "\(food)(이)가 맞습니까?", preferredStyle: .actionSheet)
            let continueAdd = UIAlertAction(title: "네", style: .default) { (action) in
                if let addViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController {
                    let nutrient = NutrientInfo(dictionary: ["calorie": 200, "carbo": 12, "prot": 23, "fat": 11 ,"sugars": 12.4, "sodium": 7.2, "cholesterol": 3.2, "satFat": 15.2, "transFat": 5.4])
                    
                    let result: [String: Any] = ["name": "김치찌개", "defaultIntake": 200, "nutrient": nutrient]
                    addViewController.image = image
                    addViewController.result = result
                    self.present(addViewController, animated: true, completion: nil)
                }
            }
            let searchFood = UIAlertAction(title: "다른음식 검색하기", style: .default) { (action) in
                if let searchFoodViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchFoodViewController") as? SearchFoodViewController {
                    let navigationController = UINavigationController(rootViewController: searchFoodViewController)
                    
                    let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.dismissSearchFood))
                    searchFoodViewController.navigationItem.leftBarButtonItem = cancelButton
                    searchFoodViewController.image = image
                    self.present(navigationController, animated: true, completion: {
                        self.predictionContainerView.isHidden = true
                    })
                    
                }
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel) { (action) in
                if let tbc = self.tabBarController as? TabBarController {
                    tbc.tabBar.isHidden = false
                    tbc.selectedIndex = tbc.index
                    self.predictionContainerView.isHidden = true
                }
            }
            alert.addAction(continueAdd)
            alert.addAction(searchFood)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func dismissSearchFood() {
        if let tbc = self.tabBarController as? TabBarController {
            tbc.tabBar.isHidden = false
            tbc.selectedIndex = tbc.index
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if let tbc = self.tabBarController as? TabBarController {
            tbc.tabBar.isHidden = false
            tbc.selectedIndex = tbc.index
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func predictFood(image: UIImage, completion: @escaping (String) -> Void) {
        let model = FoodModel()
        let size = CGSize(width: 224, height: 224)
        
        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }
        
        guard let result = try? model.prediction(image: buffer) else {
            fatalError("Prediction failed!")
        }
        
        let confidence = result.output[result.classLabel]! * 100.0
        let converted = String(format: "%.2f", confidence)
        
        DispatchQueue.main.async {
            self.predictionContainerView.isHidden = false
            self.mealImageView.image = image
            self.predictionLabel.text = "\(result.classLabel) (\(converted)%)"
        }
        
        completion(result.classLabel)
    }
}
