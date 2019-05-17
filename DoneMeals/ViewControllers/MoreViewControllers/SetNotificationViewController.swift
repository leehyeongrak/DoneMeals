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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
            }
        case "SetLunchSegue":
            if let lunchTime = UserDefaults.standard.object(forKey: "lunchTime") as? Date {
                lunchTimeLabel.text = dateFormatter.string(from: lunchTime)
            }
        case "SetDinnerSegue":
            if let dinnerTime = UserDefaults.standard.object(forKey: "dinnerTime") as? Date {
                dinnerTimeLabel.text = dateFormatter.string(from: dinnerTime)
            }
        default:
            return
        }
    }
}
