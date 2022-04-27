//
//  MealTableViewController.swift
//  MealRating
//
//  Created by Jing Li on 8/4/21.
//

import UIKit
import GRDB

enum SectionType {
    case section0
}

class MealTableViewController: UITableViewController {
    // MARK: Properties
//    // property is not needed if using diffableDataSource
//    var meals : [Meal]?
    
    let cellIdentifier = "MealTableViewCell"
    
    lazy var diffableDataSource = MealDiffableDataSource
        .init(tableView: tableView) { tableView, indexPath, meal in
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! MealTableViewCell

        cell.nameLabel.text = meal.name
        cell.ratingControl.rating = meal.rating
        if let imageData = meal.imageData {
            cell.dishImageView.image = UIImage(data: imageData)
        }
        // cell background turns grey after being tapped solution.
        cell.selectionStyle = .none

        return cell
    }
    
    var databaseCancellable: DatabaseCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
        
        setupDiffableDataSource()
        observeMeals()
    }

//    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let meals = meals else {
//            return 0
//        }
//
//        return meals.count
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
//            fatalError("Unable to dequeue meal cell.")
//        }
//
//        guard let meals = meals else {
//            return cell
//        }
//
//        let meal = meals[indexPath.row]
//
//        cell.nameLabel.text = meal.name
//        cell.ratingControl.rating = meal.rating
//
//        if let imageData = meal.imageData {
//            cell.dishImageView.image = UIImage(data: imageData)
//        }
//
//        return cell
//    }
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            guard let meals = meals else {
//                return
//            }
//
//            // GRDB delete single meal
//            if let mealId = meals[indexPath.row].id {
//                do {
//                    try AppDatabase.shared?.deleteMeal(ids: [mealId])
//                } catch let error {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? MealTableViewCell, let selectedIndexPath = tableView.indexPath(for: selectedCell), let mealDetailController = segue.destination as? MealDetailViewController {
//            mealDetailController.meal = meals[selectedIndexPath.row]
            mealDetailController.meal = diffableDataSource.itemIdentifier(for: selectedIndexPath)
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
    
    // MARK: - Private methods
    
//    // function no longer needed with Value Observation in GRDB:
//    fileprivate func setupMeals(){
//        do {
//            try AppDatabase.shared?.insertMealsIfEmpty()
//            meals = try AppDatabase.shared?.fetchMeals()
//        } catch let err {
//            print(err.localizedDescription)
//            return
//        }
//    }
        
    // uses Value Observation in GRDB,
    // thus avoids meals and tableview rows CRUD operations
    // or diffableDataSource snapshot sections/items CRUD operations if using diffableDataSource,
    // each time when a CRUD operaton happens at the database.
    fileprivate func observeMeals() {
        do {
            try AppDatabase.shared?.insertMealsIfEmpty()
        } catch let err {
            print(err.localizedDescription)
            return
        }
        
        databaseCancellable = AppDatabase.shared?.observeMeals(onError: { error in
            print(error.localizedDescription)
        }, onChange: { [weak self] meals in
            guard let self = self else {return}
            self.setupDiffableTableData(meals: meals)
//            self.meals = meals
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        })
    }
    
    fileprivate func setupDiffableDataSource() {
        tableView.dataSource = diffableDataSource
        diffableDataSource.defaultRowAnimation = UITableView.RowAnimation.left
    }
    
    fileprivate func setupDiffableTableData(meals: [Meal]) {
        // use a NEW snapshot to avoid appending the same section/items again.
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Meal>()

        snapshot.appendSections([SectionType.section0])
        snapshot.appendItems(meals, toSection: SectionType.section0)
        
        diffableDataSource.apply(snapshot)
    }
}

class MealDiffableDataSource: UITableViewDiffableDataSource<SectionType, Meal> {
    // MARK: - UITableViewDataSource methods
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            guard let meals = meals else {
//                return
//            }
//            if let mealId = meals[indexPath.row].id {
            
            // GRDB delete single meal
            if let mealId = self.itemIdentifier(for: indexPath)?.id {
                do {
                    try AppDatabase.shared?.deleteMeal(ids: [mealId])
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
