//
//  SearchFoodViewController.swift
//  DoneMeals
//
//  Created by RAK on 21/04/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class SearchFoodViewController: UIViewController {

    var samples: Array<String> = []
    var image: UIImage?
    var results: Array<String> = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        searchBar.delegate = self
        
        let service = APIService()
        service.fetchFoodList { (list, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            self.samples = list!
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let manualAddViewController = storyboard?.instantiateViewController(withIdentifier: "ManualAddViewController") as? ManualAddViewController else { return }
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let keyword = cell?.textLabel?.text ?? ""
        
        let service = APIService()
        service.searchFood(keyword: keyword) { (dictionary, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            let nutrient = NutrientInfo(dictionary: dictionary!["nutrientInfo"] as! [String : Any])

            let result: [String: Any] = ["name": keyword, "defaultIntake": dictionary!["defaultIntake"] as! Int, "nutrient": nutrient]

            if let image = self.image {
                manualAddViewController.image = image
            }
            
            manualAddViewController.result = result
            self.navigationController?.pushViewController(manualAddViewController, animated: true)
        }
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
