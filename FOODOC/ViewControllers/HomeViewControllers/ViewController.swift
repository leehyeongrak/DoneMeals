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
    
    var existUID: String?
    var user: UserInfo?
    
    @IBOutlet weak var recommendedCalorieLabel: UILabel!
    @IBOutlet weak var recommendedCarboLabel: UILabel!
    @IBOutlet weak var recommendedProtLabel: UILabel!
    @IBOutlet weak var recommendedFatLabel: UILabel!
    
    @IBOutlet weak var calorieProgressView: UIProgressView!
    @IBOutlet weak var carboProgressView: UIProgressView!
    @IBOutlet weak var protProgressView: UIProgressView!
    @IBOutlet weak var fatProgressView: UIProgressView!
    
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
        if let uid = Auth.auth().currentUser?.uid {
            existUID = uid
            checkUserInfo()
        } else {
            perform(#selector(presentLoginViewController), with: nil, afterDelay: 0)
        }
    }
    
    func checkUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if existUID != uid {
            resetViews()
            existUID = uid
        }
        
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            if let age = dictionary["age"] as? String {
                if age == "" {
                    self.presentBodyInfoViewController()
                } else {
                    let service = APIService()
                    service.fetchUserInformation(completion: { (user, error) in
                        self.user = user
                        self.fetchMealsOfToday {
                            self.updateRecommendedIntake()
                        }
                    })
                }
            }
        })
    }
    
    private func resetViews() {
        self.mealList.removeAll()
        self.breakfastList.removeAll()
        self.lunchList.removeAll()
        self.dinnerList.removeAll()
        self.mealTableView.reloadData()
        
        self.recommendedCalorieLabel.text = "0kcal/0kcal"
        self.recommendedCarboLabel.text = "0g/0g"
        self.recommendedProtLabel.text = "0g/0g"
        self.recommendedFatLabel.text = "0g/0g"
        
        self.calorieProgressView.setProgress(0.0, animated: true)
        self.carboProgressView.setProgress(0.0, animated: true)
        self.protProgressView.setProgress(0.0, animated: true)
        self.fatProgressView.setProgress(0.0, animated: true)
    }
    
    func updateRecommendedIntake() {
        var calorie = 0
        var carbo = 0
        var prot = 0
        var fat = 0
        
        for meal in mealList {
            let percentage = Double(meal.intake) / Double(meal.defaultIntake)
            calorie += Int(round(Double(meal.nutrientInfo.calorie) * percentage))
            carbo += Int(round(Double(meal.nutrientInfo.carbo) * percentage))
            prot += Int(round(Double(meal.nutrientInfo.prot) * percentage))
            fat += Int(round(Double(meal.nutrientInfo.fat) * percentage))
        }
        
        if let user = self.user {
            self.recommendedCalorieLabel.text = "\(calorie)kcal/\(Int(round(user.recommendedIntake.calorie)))kcal"
            self.recommendedCarboLabel.text = "\(carbo)g/\(Int(round(user.recommendedIntake.carbo)))g"
            self.recommendedProtLabel.text = "\(prot)g/\(Int(round(user.recommendedIntake.prot)))g"
            self.recommendedFatLabel.text = "\(fat)g/\(Int(round(user.recommendedIntake.fat)))g"
            
            self.calorieProgressView.setProgress(Float(Double(calorie)/user.recommendedIntake.calorie), animated: true)
            self.carboProgressView.setProgress(Float(Double(carbo)/user.recommendedIntake.carbo), animated: true)
            self.protProgressView.setProgress(Float(Double(prot)/user.recommendedIntake.prot), animated: true)
            self.fatProgressView.setProgress(Float(Double(fat)/user.recommendedIntake.fat), animated: true)
        }
    }
    
    func fetchMealsOfToday(completion: @escaping () -> Void) {
        self.breakfastList.removeAll()
        self.lunchList.removeAll()
        self.dinnerList.removeAll()
        
        self.activityIndicatorView.startAnimating()
        let service = APIService()
        service.fetchMealInformation(bld: Bld.Breakfast, completion: { (list, error) in
            if let list = list {
                self.mealList = list.filter({ (food) -> Bool in
                    let calender = Calendar.current
                    let date = Date(timeIntervalSince1970: TimeInterval(food.createdTime))
                    let current = Date()
                    let components = calender.dateComponents([.year, .month, .day, .hour], from: date)
                    let currentComponents = calender.dateComponents([.year, .month, .day], from: current)
                    if components.year == currentComponents.year && components.month == currentComponents.month && components.day == currentComponents.day {
                        return true
                    } else {
                        return false
                    }
                })
                
                for meal in self.mealList {
                    switch meal.bld {
                    case .Breakfast:
                        self.breakfastList.append(meal)
                    case .Lunch:
                        self.lunchList.append(meal)
                    case .Dinner:
                        self.dinnerList.append(meal)
                    }
                }
            } else {
                self.mealList = []
            }
            self.mealTableView.reloadData()
            self.activityIndicatorView.stopAnimating()
            completion()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFoodInfoSegue" {
            if let foodInfoViewController = segue.destination as? FoodInfoViewController {
                if let cell = sender as? FoodCollectionViewCell {
                    foodInfoViewController.food = cell.food
                }
            }
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
        resetViews()
    }
}

