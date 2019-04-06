//
//  SignUpViewController.swift
//  FOODOC
//
//  Created by RAK on 06/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBAction func tappedSignUpButton(_ sender: UIButton) {
        createUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createUserInfo() {
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text, let passwordConfirmText = passwordConfirmTextField.text else {
            return
        }
        
        if emailText == "" || passwordText == "" || passwordConfirmText == "" {
            let alert = UIAlertController(title: "회원가입 실패", message: "항목을 전부 입력해주세요", preferredStyle: .alert)
            present(alert, animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
            return
        } else {
            // signUp
            if passwordText == passwordConfirmText {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (user, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let value: [String: Any] = ["email": emailText, "name": "", "gender": true, "age": 0, "height": 0.0, "wieght": 0.0]
                    if let uid = user?.user.uid {
                        self.updateUserInfoIntoDatabase(uid: uid, value: value)
                    }
                }
            } else {
                let alert = UIAlertController(title: "회원가입 오류", message: "비밀번호가 일치하지 않습니다", preferredStyle: .alert)
                present(alert, animated: true) {
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
        }
    }
    
    func updateUserInfoIntoDatabase(uid: String, value: [String: Any]) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            do {
                try Auth.auth().signOut()
            } catch {
                print(error)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }

}
