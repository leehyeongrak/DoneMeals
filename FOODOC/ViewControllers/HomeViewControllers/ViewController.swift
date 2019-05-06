//
//  ViewController.swift
//  FOODOC
//
//  Created by RAK on 01/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var mealList: Array<FoodInfo> = []
    var breakfastList: Array<FoodInfo> = []
    var lunchList: Array<FoodInfo> = []
    var dinnerList: Array<FoodInfo> = []
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var mealTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        checkUserAuth()
        
        mealTableView.delegate = self
        mealTableView.dataSource = self
        mealTableView.allowsSelection = false
    }
    
    func checkUserAuth() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(presentLoginViewController), with: nil, afterDelay: 0)
        } else {
            checkUserInfo()
        }
    }
    
    func checkUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            if let age = dictionary["age"] as? String {
                if age == "" {
                    self.presentBodyInfoViewController()
                } else {
                    self.fetchMealsOfToday()
                }
            }
        })
    }
    
    private func fetchMealsOfToday() {
        self.activityIndicatorView.startAnimating()
        let service = APIService()
        service.fetchMealInformation(bld: Bld.Breakfast, completion: { (list, error) in
            if let list = list {
                self.breakfastList = list.filter({ (food) -> Bool in
                    if food.bld == Bld.Breakfast {
                        return true
                    } else {
                        return false
                    }
                })
            }
            self.mealTableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        })
    }
    
    @objc func presentLoginViewController() {
        if let welcomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            welcomeViewController.userLoggedInDelegate = self
            let navigationController = UINavigationController(rootViewController: welcomeViewController)
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    func presentBodyInfoViewController() {
        if let bodyInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "BodyInfoViewController") as? BodyInfoViewController {
            bodyInfoViewController.userLoggedOutDelegate = self
            present(bodyInfoViewController, animated: true, completion: nil)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            cell.mealTimeLabel.text = "아침"
            cell.mealList = self.breakfastList
        case 1:
            cell.mealTimeLabel.text = "점심"
            cell.mealList = self.lunchList
        case 2:
            cell.mealTimeLabel.text = "저녁"
            cell.mealList = self.dinnerList
        default:
            cell.mealTimeLabel.text = "간식"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208
    }
    
}

protocol UserLoggedInDelegate {
    func userLoggedIn()
}

protocol UserLoggedOutDelegate {
    func userLoggedOut()
}

extension ViewController: UserLoggedInDelegate, UserLoggedOutDelegate {
    func userLoggedIn() {
        checkUserInfo()
    }
    
    func userLoggedOut() {
        checkUserAuth()
    }
}

