//
//  LoginViewController.swift
//  FOODOC
//
//  Created by RAK on 06/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
//        if let bodyInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "BodyInfoViewController") as? BodyInfoViewController {
//            self.navigationController?.pushViewController(bodyInfoViewController, animated: true)
//        }
        loginFirebaseAuth()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
