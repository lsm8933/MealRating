//
//  Meal.swift
//  MealRating
//
//  Created by Jing Li on 8/2/21.
//

import UIKit
import GRDB

struct Meal: Identifiable, Hashable {
    var id: Int64?
    var name: String
    var rating: Int
    var imageData: Data?
}

extension Meal: Codable {
    enum Columns {
        static let name = Column(CodingKeys.name)
        static let rating = Column(CodingKeys.rating)
        static let imageData = Column(CodingKeys.imageData)
    }
}

extension Meal: FetchableRecord, MutablePersistableRecord {
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension Meal {
    static func newMeal() -> Meal {
        return Meal(id: nil, name: "Tofu", rating: 4, imageData: UIImage(named: "meal1")?.jpegData(compressionQuality: 0.75))
    }
    
    static func newMeals() -> [Meal] {
        return [
            Meal(id: nil, name: "Cute Buns", rating: 5, imageData: UIImage(named: "dish1")?.jpegData(compressionQuality: 1)),
            Meal(id: nil, name: "Delicious Chinese Food", rating: 4, imageData: UIImage(named: "dish2")?.jpegData(compressionQuality: 1)),
            Meal(id: nil, name: "Tasty Delight", rating: 4, imageData: UIImage(named: "dish3")?.jpegData(compressionQuality: 1))
        ]
    }
}
