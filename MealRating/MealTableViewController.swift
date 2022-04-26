//
//  MealTableViewController.swift
//  MealRating
//
//  Created by Jing Li on 8/4/21.
//

import UIKit
import GRDB

//enum SectionType {
//    case section0
//}

class MealTableViewController: UITableViewController {
    // MARK: Properties
    var meals : [Meal]?
    
    let cellIdentifier = "MealTableViewCell"
    
//    lazy var diffableDataSource = MealDiffableDataSource
//        .init(tableView: tableView) { tableView, indexPath, meal in
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! MealTableViewCell
//
//        cell.nameLabel.text = meal.name
//        cell.ratingControl.rating = meal.rating
//        if let imageData = meal.imageData {
//            cell.dishImageView.image = UIImage(data: imageData)
//        }
//
//        return cell
//    }
    var databaseCancellable: DatabaseCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
        
        observeMeals()
        //setupDiffableDataSource()
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
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? MealTableViewCell, let selectedIndexPath = tableView.indexPath(for: selectedCell), let mealDetailController = segue.destination as? MealDetailViewController, let meals = meals {
            mealDetailController.meal = meals[selectedIndexPath.row]
        }
    }
    
    // MARK: - Navigation IBAction
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard let sourceController = segue.source as? MealDetailViewController, var meal = sourceController.meal else {
            return
        }
        
        // GRDB insert/update single meal
        do {
            try AppDatabase.shared?.saveMeal(meal: &meal)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Private methods
    
    // function no longer needed with Value Observation in GRDB:
    fileprivate func setupMeals(){
        do {
            try AppDatabase.shared?.insertMealsIfEmpty()
            meals = try AppDatabase.shared?.fetchMeals()
        } catch let err {
            print(err.localizedDescription)
            return
        }
    }
    
//    fileprivate func setupDiffableDataSource() {
//        diffableDataSource.defaultRowAnimation = .fade
//        tableView.dataSource = diffableDataSource
//    }
    
    // uses Value Observation in GRDB,
    // thus avoids the operations on meals and tableview each time a CRUD operaton happens at the database.
    fileprivate func observeMeals() {
        do {
            try AppDatabase.shared?.insertMealsIfEmpty()
        } catch let err {
            print(err.localizedDescription)
            return
        }
        
        databaseCancellable = AppDatabase.shared?.observeMeals(onError: { error in
            print(error.localizedDescription)
        }, onChange: { meals in
            self.meals = meals
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}

//class MealDiffableDataSource: UITableViewDiffableDataSource<SectionType, Meal> {
//    
//}
