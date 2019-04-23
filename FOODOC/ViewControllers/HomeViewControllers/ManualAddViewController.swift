//
//  ManualAddViewController.swift
//  FOODOC
//
//  Created by RAK on 23/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class ManualAddViewController: UIViewController {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodIntakeTextField: UITextField!
    @IBOutlet weak var intakeDateButton: UIButton!
    
    @IBOutlet weak var nutrientTableView: UITableView!
    
    @IBAction func tappedDoneButton(_ sender: UIBarButtonItem) {
    }
    
    let coverView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coverView.backgroundColor = .black
        coverView.alpha = 0
        coverView.frame = view.bounds
        coverView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dateSelectViewController = segue.destination as? DateSelectViewController
        
        dateSelectViewController?.dismissViewControllerDelegate = self
        
        self.navigationController?.view.addSubview(coverView)
        UIView.animate(withDuration: 0.3) { self.coverView.alpha = 0.6 }
    }

}

extension ManualAddViewController: DismissViewControllerDelegate {
    func removeCoverView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.coverView.alpha = 0
        }) { (bool) in
            self.coverView.removeFromSuperview()
        }
    }
}
