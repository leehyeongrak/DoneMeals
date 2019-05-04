//
//  ManualAddViewController.swift
//  FOODOC
//
//  Created by RAK on 23/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class ManualAddViewController: UIViewController {
    
    var food: FoodInfo?
    var result: [String: Any]?
    var date: Date?
    
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
        
        nutrientTableView.delegate = self
        nutrientTableView.dataSource = self
        
        foodIntakeTextField.delegate = self
        addDoneButtonOnKeyboard()
        
        if let selectedFood = result {
            foodNameLabel.text = selectedFood["name"] as? String
            foodIntakeTextField.text = "\((selectedFood["defaultIntake"] as? Double) ?? 0)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dateSelectViewController = segue.destination as? DateSelectViewController
        
        dateSelectViewController?.dismissViewControllerDelegate = self
        
        self.navigationController?.view.addSubview(coverView)
        UIView.animate(withDuration: 0.3) { self.coverView.alpha = 0.6 }
    }

}

extension ManualAddViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientTableViewCell", for: indexPath) as? NutrientTableViewCell else { return UITableViewCell() }
        
        let intakeText = foodIntakeTextField.text ?? "0"
        
        if let selectedFood = result {
            
            if let nutrient = selectedFood["nutrient"] as? NutrientInfo, let intake = Double(intakeText), let defaultIntake = selectedFood["defaultIntake"] as? Double {
                switch indexPath.row {
                case 0:
                    cell.nutrientNameLabel.text = "칼로리"
                    cell.nutrientValueLabel.text = "0kcal"
                case 1:
                    cell.nutrientNameLabel.text = "탄수화물"
                    cell.nutrientValueLabel.text = "\(nutrient.carbo*(intake/defaultIntake))g"
                case 2:
                    cell.nutrientNameLabel.text = "단백질"
                    cell.nutrientValueLabel.text = "\(nutrient.prot*(intake/defaultIntake))g"
                case 3:
                    cell.nutrientNameLabel.text = "지방"
                    cell.nutrientValueLabel.text = "\(nutrient.fat*(intake/defaultIntake))g"
                case 4:
                    cell.nutrientNameLabel.text = "당류"
                    cell.nutrientValueLabel.text = "\(nutrient.sugars*(intake/defaultIntake))g"
                case 5:
                    cell.nutrientNameLabel.text = "나트륨"
                    cell.nutrientValueLabel.text = "\(nutrient.sodium*(intake/defaultIntake))mg"
                case 6:
                    cell.nutrientNameLabel.text = "콜레스테롤"
                    cell.nutrientValueLabel.text = "\(nutrient.cholesterol*(intake/defaultIntake))mg"
                case 7:
                    cell.nutrientNameLabel.text = "포화지방산"
                    cell.nutrientValueLabel.text = "\(nutrient.satFat*(intake/defaultIntake))g"
                default:
                    cell.nutrientNameLabel.text = "트랜스지방산"
                    cell.nutrientValueLabel.text = "\(nutrient.transFat*(intake/defaultIntake))g"
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
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

extension ManualAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.nutrientTableView.reloadData()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        let components = string.components(separatedBy: inverseSet)
        
        let filtered = components.joined(separator: "")
        
        return string == filtered
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        foodIntakeTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        foodIntakeTextField.resignFirstResponder()
        self.nutrientTableView.reloadData()
    }
}
