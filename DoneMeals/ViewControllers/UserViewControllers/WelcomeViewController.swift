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
        let signUpButtonOriginalTransfrom = signUpButton.transform
        let loginButtonOriginalTransform = loginButton.transform
        
        let scaledTransform = originalTransform.scaledBy(x: 0.1, y: 0.1)
        let signUpbButtonTranslatedTransform = signUpButtonOriginalTransfrom.translatedBy(x: 0.0, y: 300.0)
        let loginButtonTranslateTransform = loginButtonOriginalTransform.translatedBy(x: 0.0, y: 200.0)
        
        logoImageView.transform = scaledTransform
        signUpButton.transform = signUpbButtonTranslatedTransform
        loginButton.transform = loginButtonTranslateTransform
        
        UIView.animate(withDuration: 0.7, animations: {
            self.logoImageView.transform = originalTransform.scaledBy(x: 1.1, y: 1.1)
            self.signUpButton.transform = signUpButtonOriginalTransfrom.translatedBy(x: 0.0, y: -30.0)
            self.loginButton.transform = loginButtonOriginalTransform.translatedBy(x: 0.0, y: -20.0)
        }) { (bool) in
            UIView.animate(withDuration: 0.2, animations: {
                self.logoImageView.transform = self.logoImageView.transform.scaledBy(x: 0.9, y: 0.9)
                self.signUpButton.transform = signUpButtonOriginalTransfrom.translatedBy(x: 0.0, y: 15.0)
                self.loginButton.transform = loginButtonOriginalTransform.translatedBy(x: 0.0, y: 10.0)
            }) { (bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.logoImageView.transform = originalTransform
                    self.signUpButton.transform = signUpButtonOriginalTransfrom
                    self.loginButton.transform = loginButtonOriginalTransform
                })
            }
        }
    }
    
}
