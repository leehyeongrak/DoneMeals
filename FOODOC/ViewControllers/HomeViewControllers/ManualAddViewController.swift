//
//  ManualAddViewController.swift
//  FOODOC
//
//  Created by RAK on 23/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import NotificationCenter

class ManualAddViewController: UIViewController {
    
    var result: [String: Any]?
    var date: Date?
    var nutrient: NutrientInfo?
    var bld: Bld?
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodIntakeTextField: UITextField!
    @IBOutlet weak var intakeDateButton: UIButton!
    
    @IBOutlet weak var nutrientTableView: UITableView!
    
    @IBAction func tappedDoneButton(_ sender: UIBarButtonItem) {
        let service = APIService()
        
        let timestamp = Int(self.date!.timeIntervalSince1970)
        let values: [String: Any] = ["name": foodNameLabel.text!, "intake": Int(foodIntakeTextField.text!) ?? 0, "defaultIntake": result?["defaultIntake"] ?? 0, "createdTime": timestamp, "imageURL": "", "nutrientInfo": nutrient!.dictionary as NSDictionary, "bld": bld!.rawValue]
        
        service.addMealInformation(values: values, timestamp: timestamp) { (error) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CompleteAddMeal"), object: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
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
            foodIntakeTextField.text = "\((selectedFood["defaultIntake"] as? Int) ?? 0)"
            self.nutrient = selectedFood["nutrient"] as? NutrientInfo
        }
        setupIntakeDate(date: Date(), bld: nil)
    }
    
    private func setupIntakeDate(date: Date, bld: Bld?) {
        self.date = date
        let dateFormatter = DateFormatter()
        let calender = Calendar.current
        let components = calender.dateComponents([.hour], from: date)
        
        // bld means breakfast or lunch or dinner
        if let bldValue = bld {
            dateFormatter.dateFormat = "M월 d일 \(bldValue.rawValue)"
            self.bld = bld
        } else {
            var defaultBld = Bld.Breakfast
            if let hour = components.hour {
                if hour < 11 {
                    defaultBld = .Breakfast
                } else if hour >= 11 && hour < 17 {
                    defaultBld = .Lunch
                } else {
                    defaultBld = .Dinner
                }
            }
            self.bld = defaultBld
            dateFormatter.dateFormat = "M월 d일 \(defaultBld.rawValue)"
        }
        
        let dateText = dateFormatter.string(from: date)
        intakeDateButton.setTitle(dateText, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dateSelectViewController = segue.destination as? DateSelectViewController
        
        dateSelectViewController?.dismissViewControllerDelegate = self
        dateSelectViewController?.dateSelectedDelegate = self
        
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
            
            if let nutrient = selectedFood["nutrient"] as? NutrientInfo, let intake = Int(intakeText), let defaultIntake = selectedFood["defaultIntake"] as? Int {
                
                let percentage = Double(intake)/Double(defaultIntake)
                
                switch indexPath.row {
                case 0:
                    cell.nutrientNameLabel.text = "칼로리"
                    cell.nutrientValueLabel.text = "\(Int(round(Double(nutrient.calorie) * percentage)))kcal"
                case 1:
                    cell.nutrientNameLabel.text = "탄수화물"
                    cell.nutrientValueLabel.text = "\(Int(round(Double(nutrient.carbo) * percentage)))g"
                case 2:
                    cell.nutrientNameLabel.text = "단백질"
                    cell.nutrientValueLabel.text = "\(Int(round(Double(nutrient.prot) * percentage)))g"
                case 3:
                    cell.nutrientNameLabel.text = "지방"
                    cell.nutrientValueLabel.text = "\(Int(round(Double(nutrient.fat) * percentage)))g"
                case 4:
                    cell.nutrientNameLabel.text = "당류"
                    cell.nutrientValueLabel.text = "\(nutrient.sugars * percentage)g"
                case 5:
                    cell.nutrientNameLabel.text = "나트륨"
                    cell.nutrientValueLabel.text = "\(nutrient.sodium * percentage)mg"
                case 6:
                    cell.nutrientNameLabel.text = "콜레스테롤"
                    cell.nutrientValueLabel.text = "\(nutrient.cholesterol * percentage)mg"
                case 7:
                    cell.nutrientNameLabel.text = "포화지방산"
                    cell.nutrientValueLabel.text = "\(nutrient.satFat * percentage)g"
                default:
                    cell.nutrientNameLabel.text = "트랜스지방산"
                    cell.nutrientValueLabel.text = "\(nutrient.transFat * percentage)g"
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

protocol DateSelectedDelegate {
    func dateSelected(date: Date, bld: Bld)
}

extension ManualAddViewController: DateSelectedDelegate {
    func dateSelected(date: Date, bld: Bld) {
        setupIntakeDate(date: date, bld: bld)
    }
}
