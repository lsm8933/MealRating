//
//  MealTableViewController.swift
//  MealRating
//
//  Created by Jing Li on 8/4/21.
//

import UIKit

class MealTableViewController: UITableViewController {
    // MARK: Properties
    var meals : [Meal]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
        
        setupData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let meals = meals else {
            return 0
        }

        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("Unable to dequeue meal cell.")
        }
        
        guard let meals = meals else {
            return cell
        }
        
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.ratingControl.rating = meal.rating

        if let imageData = meal.imageData {
            cell.dishImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let meals = meals else {
                return
            }

            // GRDB delete single meal
            if let mealId = meals[indexPath.row].id {
                do {
                    try AppDatabase.shared?.deleteMeal(ids: [mealId])
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
            // Delete the row from the data source
            self.meals?.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }    
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? MealTableViewCell, let selectedIndexPath = tableView.indexPath(for: selectedCell), let mealDetailController = segue.destination as? MealDetailViewController, let meals = meals {
            mealDetailController.meal = meals[selectedIndexPath.row]
        }
    }
    
    // MARK: - Navigation IBAction
    // Navigation
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        if let sourceController = segue.source as? MealDetailViewController, var meal = sourceController.meal {
            // If coming from editing existing meal
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                self.meals?[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            } else { // If coming from adding a new meal
                if meals == nil {
                    meals = []
                }

                meals?.append(meal)
                
                if let mealsCount = meals?.count {
                    let newIndexPath = IndexPath(row: mealsCount - 1, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            }

            // GRDB insert/update single meal
            do {
                try AppDatabase.shared?.saveMeal(meal: &meal)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Private methods
    private func setupData(){
        do {
            try AppDatabase.shared?.insertMealsIfEmpty()
            meals = try AppDatabase.shared?.fetchMeals()
        } catch let err {
            print(err.localizedDescription)
            return
        }
    }
}
