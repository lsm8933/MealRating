//
//  Persistence.swift
//  MealRating
//
//  Created by Jing Li on 3/31/22.
//

import Foundation
import GRDB

extension AppDatabase {
    static var shared: AppDatabase? {
        if instance == nil {
            instance = makeAppDatabase()
        }
        
        return instance
    }
    
    private static var instance: AppDatabase? = makeAppDatabase()
    
    private static func makeAppDatabase() -> AppDatabase? {
        do {
            let fileManager = FileManager.default
            let url = try fileManager.url(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("database")
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            
            let dbUrl = url.appendingPathComponent("db.sqlite")
            
            let dbPool = try DatabasePool(path: dbUrl.path)
            
            let appDatabase = try AppDatabase(dbWriter: dbPool)
            
            return appDatabase
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
