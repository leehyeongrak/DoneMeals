//
//  MoreViewController.swift
//  FOODOC
//
//  Created by RAK on 10/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class MoreViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var userInfo: UserInfo?
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                present(mailComposeViewController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "메일 전송에 실패하였습니다.", message: "이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else if indexPath.row == 3 {
            let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "네", style: .default, handler: { (action) in
                self.signOutFirebaseAuth()
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            if activityIndicatorView.isAnimating {
                return nil
            }
        }
        return indexPath
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients(["leehrak@gmail.com"])
        mailComposeViewController.setSubject("FOODOC 문의하기")
        mailComposeViewController.setMessageBody("소중한 의견을 주셔서 감사합니다.", isHTML: false)
        
        return mailComposeViewController
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func signOutFirebaseAuth() {
        do {
            if let vc = self.tabBarController?.viewControllers![0] as? ViewController {
                try Auth.auth().signOut()
                self.tabBarController?.selectedIndex = 0
                vc.checkUserAuth()
            }
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditBodyInfoViewController {
            if let info = self.userInfo {
                vc.userInfo = info
                vc.updateDataDelegate = self
            }
        }
    }
    
    private func fetchData() {
        let service = APIService()
        activityIndicatorView.startAnimating()
        service.fetchUserInformation { (userInfo, error) in
            if error != nil {
                print(error!)
                return
            }
            if let info = userInfo {
                self.userInfo = info
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
}

protocol UpdateDataDelegate {
    func updateData()
}

extension MoreViewController: UpdateDataDelegate {
    func updateData() {
        fetchData()
    }
}
