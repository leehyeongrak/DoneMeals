//
//  AddViewController.swift
//  FOODOC
//
//  Created by RAK on 06/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if let tbc = self.tabBarController as? TabBarController {
            tbc.selectedIndex = tbc.index
        }
        self.dismiss(animated: true, completion: nil)
    }
}
