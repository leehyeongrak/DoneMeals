//
//  TabBarController.swift
//  FOODOC
//
//  Created by RAK on 07/05/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var index: Int = 0
    let imagePickerView = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
        } else {
            index = item.tag
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let vc = viewController as? AddViewController else { return }
        imagePickerView.delegate = vc
        imagePickerView.sourceType = .camera
        vc.present(imagePickerView, animated: true, completion: nil)
    }
}
