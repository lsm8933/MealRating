//
//  MealTableViewController.swift
//  MealRating
//
//  Created by Jing Li on 8/4/21.
//

import UIKit

class MealTableViewController: UITableViewController {
    // MARK: Properties
    var meals : [Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !loadMeals() {
            loadPreSavedMeals()
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("Unable to dequeue meal cell.")
        }
        
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.ratingControl.rating = meal.rating
        cell.dishImageView.image = meal.photo
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals(meals)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }    
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? MealTableViewCell, let selectedIndexPath = tableView.indexPath(for: selectedCell), let mealDetailController = segue.destination as? MealDetailViewController {
            mealDetailController.meal = meals[selectedIndexPath.row]
        }
    }
    
    // MARK: Navigation IBAction
    // Navigation
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        if let sourceController = segue.source as? MealDetailViewController, let meal = sourceController.meal {
            // If coming from editing existing meal
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            } else { // If coming from adding a new meal
                meals.append(meal)
                
                let newIndexPath = IndexPath(row: meals.count - 1, section: 0)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveMeals(meals)
        }
    }
    
    // MARK: Private methods
    private func saveMeals(_ meals: [Meal]) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false)
            try data.write(to: Meal.path)
        } catch {
            print("Unable to save meals: \(error.localizedDescription)")
        }
    }
    
    private func loadMeals() -> Bool {
        do {
            let data = try Data.init(contentsOf: Meal.path)
            if let meals =  try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Meal] {
                self.meals = meals
                return true
            }
        } catch {
            print("Unable to load meals: \(error.localizedDescription)")
        }
        return false
    }
    
    private func loadPreSavedMeals() {
        let meal1Image = UIImage(named: "dish1")
        let meal2Image = UIImage(named: "dish2")
        let meal3Image = UIImage(named: "dish3")
        
        guard let meal1 = Meal(name: "Cute Buns", photo: meal1Image, rating: 5) else {
            fatalError("Unable to create pre-saved meal")
        }
        guard let meal2 = Meal(name: "Delicious Chinese Food", photo: meal2Image, rating: 4) else {
            fatalError("Unable to create pre-saved meal")
        }
        guard let meal3 = Meal(name: "Tasty Delight", photo: meal3Image, rating: 4) else {
            fatalError("Unable to create pre-saved meal")
        }
        
        meals.append(contentsOf: [meal1, meal2, meal3])
    }

}
