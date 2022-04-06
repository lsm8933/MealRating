//
//  AppDatabase.swift
//  MealRating
//
//  Created by Jing Li on 3/31/22.
//

import Foundation
import GRDB

final class AppDatabase {
    private let dbWriter: DatabaseWriter
    
    private var dbMigrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("createMeal") { db in
            try db.create(table: "meal") { table in
                table.autoIncrementedPrimaryKey("id")
                table.column("name", Database.ColumnType.text).notNull()
                table.column("rating", Database.ColumnType.integer).defaults(to: 0)
                table.column("imageData", Database.ColumnType.blob)
            }
        }
        
        return migrator
    }
    
    init(dbWriter: DatabaseWriter) throws {
        self.dbWriter = dbWriter
        try dbMigrator.migrate(dbWriter)
    }
}

extension AppDatabase {
    func insertMealsIfEmpty() throws {
        try dbWriter.write({ db in
            guard try Meal.fetchCount(db) == 0 else {
                return
            }
            
            let newMeals = Meal.newMeals()

            for var newMeal in newMeals {
                try newMeal.insert(db)
            }
        })
    }
    
    func fetchCount() throws -> Int {
        try dbWriter.read({ db in
            try Meal.fetchCount(db)
        })
    }
    
    func fetchMeals() throws -> [Meal] {
        try dbWriter.read({ db in
            try Meal.fetchAll(db)
        })
    }
    
    
    func saveMeal(meal: inout Meal) throws {
        try dbWriter.write { db in
            try meal.save(db)
        }
    }
    
    func deleteMeal(ids: [Int64]) throws {
        try dbWriter.write { db in
            _ = try Meal.deleteAll(db, ids: ids)
        }
    }
    
    func deleteAllMeal() throws {
        let _ = try dbWriter.write({ db in
            try Meal.deleteAll(db)
        })
    }
}
