//
//  SetNotificationViewController.swift
//  DoneMeals
//
//  Created by RAK on 14/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class SetNotificationViewController: UITableViewController {
    
    let coverView = UIView()
    
    @IBOutlet weak var breakfastTimeLabel: UILabel!
    @IBOutlet weak var lunchTimeLabel: UILabel!
    @IBOutlet weak var dinnerTimeLabel: UILabel!
    
    @IBOutlet weak var breakfastSwitch: UISwitch!
    @IBOutlet weak var lunchSwitch: UISwitch!
    @IBOutlet weak var dinnerSwitch: UISwitch!
    
    @IBAction func changedBreakfastSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "breakfastSwitch")
        if let breakfastTime = UserDefaults.standard.object(forKey: "breakfastTime") as? Date {
            if sender.isOn {
                NotificationManager.addTimeNotification(bld: .Breakfast, date: breakfastTime)
            } else {
                NotificationManager.removeTimeNotification(bld: .Breakfast)
            }
        }
    }
    @IBAction func changedLunchSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "lunchSwitch")
        if let lunchTime = UserDefaults.standard.object(forKey: "lunchTime") as? Date {
            if sender.isOn {
                NotificationManager.addTimeNotification(bld: .Lunch, date: lunchTime)
            } else {
                NotificationManager.removeTimeNotification(bld: .Lunch)
            }
        }
    }
    @IBAction func changedDinnerSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "dinnerSwitch")
        if let dinnerTime = UserDefaults.standard.object(forKey: "dinnerTime") as? Date {
            if sender.isOn {
                NotificationManager.addTimeNotification(bld: .Dinner, date: dinnerTime)
            } else {
                NotificationManager.removeTimeNotification(bld: .Dinner)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        coverView.backgroundColor = .black
        coverView.alpha = 0
        coverView.frame = view.bounds
        coverView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setupViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        
        if let breakfastTime = UserDefaults.standard.object(forKey: "breakfastTime") as? Date {
            breakfastTimeLabel.text = dateFormatter.string(from: breakfastTime)
        }
        
        if let lunchTime = UserDefaults.standard.object(forKey: "lunchTime") as? Date {
            lunchTimeLabel.text = dateFormatter.string(from: lunchTime)
        }
        
        if let dinnerTime = UserDefaults.standard.object(forKey: "dinnerTime") as? Date {
            dinnerTimeLabel.text = dateFormatter.string(from: dinnerTime)
        }
        
        breakfastSwitch.setOn(UserDefaults.standard.bool(forKey: "breakfastSwitch"), animated: true)
        lunchSwitch.setOn(UserDefaults.standard.bool(forKey: "lunchSwitch"), animated: true)
        dinnerSwitch.setOn(UserDefaults.standard.bool(forKey: "dinnerSwitch"), animated: true)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let timeSelectViewController = segue.destination as? TimeSelectViewController
        
        timeSelectViewController?.segueIdentifier = segue.identifier
        timeSelectViewController?.dismissViewControllerDelegate = self
        timeSelectViewController?.valueSelectedDelegate = self
        
        self.navigationController?.view.addSubview(coverView)
        UIView.animate(withDuration: 0.3) { self.coverView.alpha = 0.6 }
    }

}

extension SetNotificationViewController: DismissViewControllerDelegate {
    func removeCoverView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.coverView.alpha = 0
        }) { (bool) in
            self.coverView.removeFromSuperview()
        }
    }
}

extension SetNotificationViewController: ValueSelectedDelegate {
    func valueSelected(segueIdentifier: String, value: Any?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        switch segueIdentifier {
        case "SetBreakfastSegue":
            if let breakfastTime = UserDefaults.standard.object(forKey: "breakfastTime") as? Date {
                breakfastTimeLabel.text = dateFormatter.string(from: breakfastTime)
                if breakfastSwitch.isOn {
                    NotificationManager.removeTimeNotification(bld: .Breakfast)
                    NotificationManager.addTimeNotification(bld: .Breakfast, date: breakfastTime)
                }
            }
        case "SetLunchSegue":
            if let lunchTime = UserDefaults.standard.object(forKey: "lunchTime") as? Date {
                lunchTimeLabel.text = dateFormatter.string(from: lunchTime)
                if lunchSwitch.isOn {
                    NotificationManager.removeTimeNotification(bld: .Lunch)
                    NotificationManager.addTimeNotification(bld: .Lunch, date: lunchTime)
                }
            }
        case "SetDinnerSegue":
            if let dinnerTime = UserDefaults.standard.object(forKey: "dinnerTime") as? Date {
                dinnerTimeLabel.text = dateFormatter.string(from: dinnerTime)
                if dinnerSwitch.isOn {
                    NotificationManager.removeTimeNotification(bld: .Dinner)
                    NotificationManager.addTimeNotification(bld: .Dinner, date: dinnerTime)
                }
            }
        default:
            return
        }
    }
}
