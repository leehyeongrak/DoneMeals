//
//  TabBarController.swift
//  DoneMeals
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
        guard let vc = viewController as? PredictViewController else { return }
        
        let alert = UIAlertController(title: nil, message: "사진을 불러올 방법을 선택하세요", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary(viewController: vc)
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera(viewController: vc)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { (action) in
            self.cancelImagePicker()
        }
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func openLibrary(viewController: UIViewController) {
        guard let vc = viewController as? PredictViewController else { return }
        imagePickerView.delegate = vc
        imagePickerView.sourceType = .photoLibrary
        vc.present(imagePickerView, animated: true, completion: nil)
    }
    
    func openCamera(viewController: UIViewController) {
        if UIImagePickerController.availableMediaTypes(for: .camera) == nil {
            print("카메라를 사용할 수 없습니다.")
            cancelImagePicker()
            return
        }
        guard let vc = viewController as? PredictViewController else { return }
        imagePickerView.delegate = vc
        imagePickerView.sourceType = .camera
        vc.present(imagePickerView, animated: true, completion: nil)
    }
    
    func cancelImagePicker() {
        self.tabBar.isHidden = false
        self.selectedIndex = self.index
    }
}
