//
//  SearchFoodViewController.swift
//  DoneMeals
//
//  Created by RAK on 21/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class SearchFoodViewController: UIViewController {

    let samples: Array<String> = ["김치찌개", "된장찌개", "육개장"]
    var image: UIImage?
    var results: Array<String> = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    private func searchFood(keyword: String) -> Array<String> {
        let results = samples.filter { (sample) -> Bool in
            if sample.contains(keyword) {
                return true
            } else {
                return false
            }
        }
        return results
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let manualAddViewController = segue.destination as? ManualAddViewController else {
            return
        }
        guard let cell = sender as? UITableViewCell else {
            return
        }
        
        let nutrient = NutrientInfo(dictionary: ["calorie": 200, "carbo": 12, "prot": 23, "fat": 11 ,"sugars": 12.4, "sodium": 7.2, "cholesterol": 3.2, "satFat": 15.2, "transFat": 5.4])
        
        let result: [String: Any] = ["name": "김치찌개", "defaultIntake": 200, "nutrient": nutrient]
        
        if let image = self.image {
            manualAddViewController.image = image
        }
        manualAddViewController.result = result
    }
    
}

extension SearchFoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath)
        let result = results[indexPath.row]
        cell.textLabel?.text = result
        return cell
    }
    
    
}

extension SearchFoodViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            self.results = searchFood(keyword: keyword)
        }
        
        self.resultsTableView.reloadData()
        self.view.endEditing(true)
    }
}
