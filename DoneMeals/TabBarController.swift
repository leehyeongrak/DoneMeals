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
    
    let button = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        button.addTarget(self, action: #selector(tappedCameraButton), for: .touchUpInside)
        
        button.setImage(UIImage(named: "CameraIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lightGray
        
        button.frame = CGRect(x: 100, y: 0, width: 44 , height: 44)
        button.backgroundColor = .white
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.themeColor.cgColor

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 2.0
        
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.25
        
//        let tabBarItems = tabBar.items! as [UITabBarItem]
//        tabBarItems[2].title = nil
//        tabBarItems[2].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        // Do any additional setup after loading the view.
    }
    
    @objc private func tappedCameraButton() {
        self.selectedIndex = 2
        if let vc = self.viewControllers![2] as? PredictViewController {
            self.button.isHidden = true
            self.tabBarController(self, didSelect: vc)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(x: Int(self.tabBar.center.x) - 40, y: Int(self.view.bounds.height) - 74, width: 80, height: 80)
        button.layer.cornerRadius = 40
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
        self.button.isHidden = false
        self.selectedIndex = self.index
    }
}
