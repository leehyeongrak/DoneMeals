//
//  WelcomeViewController.swift
//  DoneMeals
//
//  Created by RAK on 06/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var userLoggedInDelegate: UserLoggedInDelegate?
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        animateViews()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .darkGray
        
        signUpButton.layer.cornerRadius = 30
        signUpButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 30
        loginButton.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    func animateViews() {
        let originalTransform = logoImageView.transform
        let originalLabelTransfrom = welcomeLabel.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.1, y: 0.1)
        let translatedTransform = originalLabelTransfrom.translatedBy(x: 1000, y: 0)
        logoImageView.transform = scaledTransform
        welcomeLabel.transform = translatedTransform
        UIView.animate(withDuration: 0.7, animations: {
            self.logoImageView.transform = originalTransform
        }) { (bool) in
            UIView.animate(withDuration: 0.2, animations: {
                self.logoImageView.transform = self.logoImageView.transform.scaledBy(x: 0.9, y: 0.9)
                self.welcomeLabel.transform = originalLabelTransfrom
            })
        }
    }
    
}
