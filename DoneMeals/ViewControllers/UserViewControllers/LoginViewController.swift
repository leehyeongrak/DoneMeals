//
//  LoginViewController.swift
//  DoneMeals
//
//  Created by RAK on 06/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var userLoggedInDelegate: UserLoggedInDelegate?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        loginFirebaseAuth()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backItem?.title = ""
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func loginFirebaseAuth() {
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else {
            return
        }
        
        if emailText == "" || passwordText == "" {
            let alert = UIAlertController(title: "로그인 실패", message: "항목을 전부 입력해주세요", preferredStyle: .alert)
            present(alert, animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
            return
        } else {
            Auth.auth().signIn(withEmail: emailText, password: passwordText) { (user, error) in
                if error != nil {
                    print(error!)
                    let alert = UIAlertController(title: "로그인 실패", message: "이메일과 패스워드를 다시 확인해주세요", preferredStyle: .alert)
                    self.present(alert, animated: true) {
                        self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                if let welcomeViewController = self.navigationController?.viewControllers[0] as? WelcomeViewController {
                    welcomeViewController.userLoggedInDelegate?.userLoggedIn()
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
