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
        predictionContainerView.isHidden = false
        mealImageView.image = image
        
    }
}
